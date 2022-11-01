# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Items
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :items

        def perform(options)
          # check
          return if options['proxies'].nil? || options['proxies'].empty? || options['library'].nil? || options['user'].nil? || options['event'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])

            # get item
            proxies = options['proxies']
            library = Narra::Library.find(options['library'])
            user = Narra::Auth::User.find(options['user'])

            # fire event
            @event.run!

            proxies.each_with_index do |p, i|
              # parse proxy
              proxy = Narra::SPI::Models::Proxy.parse(p)
              # connector container
              connector = Narra::Core.connector(proxy.connector).new(proxy)

              # item container
              item = nil

              # recognize type
              case connector.proxy.type
              when :video
                # create specific item
                item = Narra::Video.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, connector: connector.proxy.connector.to_s, library: library)
                # push specific metadata
                item.meta.new(name: 'type', value: :video, generator: :source)
              when :image
                # create specific item
                item = Narra::Image.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, connector: connector.proxy.connector.to_s, library: library)
                # push specific metadata
                item.meta.new(name: 'type', value: :image, generator: :source)
              when :audio
                # create specific item
                item = Narra::Audio.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, connector: connector.proxy.connector.to_s, library: library)
                # push specific metadata
                item.meta.new(name: 'type', value: :audio, generator: :source)
              when :text
                # create specific item
                item = Narra::Text.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, connector: connector.proxy.connector.to_s, library: library)
                # push specific metadata
                item.meta.new(name: 'type', value: :text, generator: :source)
              end

              # # save ingest if exist
              if item.url.include?(ENV['NARRA_STORAGE_HOSTNAME'])
                # get ingest id
                match = item.url.match(/.*ingest\/(?<ingest>.*)\/.*/)
                # find ingest
                ingest = Narra::Ingest.find(match[:ingest])
                # check and save
                if ingest
                  item.ingest = ingest
                end
              end

              # create source metadata from essential fields
              item.meta.new(name: 'name', value: connector.proxy.name, generator: :source)
              item.meta.new(name: 'url', value: item.url, generator: :source)
              item.meta.new(name: 'connector', value: connector.proxy.connector.to_s, generator: :source)

              # parse metadata from connector if exists
              connector.metadata.each do |meta|
                if !meta[:name].nil? and !meta[:value].nil?
                  # empty marks
                  object = item.meta.new(name: meta[:name], value: meta[:value], generator: connector.proxy.connector.to_s)
                  # check for marks
                  if !meta[:positions].nil? and !meta[:positions].empty?
                    meta[:positions].each do |position|
                      object.input = position['in'] if position['in']
                      object.output = position['out'] if position['out']
                    end
                  end
                end
              end

              # parse metadata form the user input if exists
              if connector.proxy.options[:user_metadata]
                connector.proxy.options[:user_metadata].each do |meta|
                  item.meta.new(name: meta[:name], value: meta[:value], generator: :user)
                end
              end

              # # check for author and if not exists add current one
              if item.meta.where(name: 'author').empty?
                item.meta.new(name: 'author', value: user.name, generator: :user)
              end

              # find if this name already exists
              existing = Narra::Item.find_by(name: item.name, library: library._id.to_s)
              # check
              if existing
                # check if it was acquired by same connector
                if existing.meta.find_by(name: 'connector', generator: 'source').value == connector.proxy.connector.to_s
                  # it has a same source it will be overwritten
                  existing.destroy!
                end
              end

              # Generate text preview
              if item.type == :text
                item.preview = Core::Items.truncate(item.text, length: Narra::Tools::Settings.text_preview_length.to_i)
              end

              # save item
              item.save!

              # start transcode process
              unless item.type == :text
                Narra::Core.process(type: :transcoder, item: item._id.to_s, identifier: connector.proxy.download_url)
              end

              # update progress
              set_progress((i + 1) / proxies.size)
            end

            # update library stats
            library.update_stats
          rescue => e
            # reset event
            @event.reset!
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'items')
            # throw
            raise e
          else
            # finish progress
            set_progress(1.0)
            # log
            Narra::Core::LOGGER.log_info('Items successfully created', 'items')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
