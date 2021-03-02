#
# Copyright (C) 2021 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>
#

require 'sidekiq'

module Narra
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
          user = Narra::User.find(options['user'])

          # fire event
          @event.run!

          proxies.each_with_index do |p, i|
            # parse proxy
            proxy = Narra::Tools::Proxy.parse(p)
            # connector container
            connector = Narra::Core.connector(proxy.connector).new(proxy)

            # item container
            item = nil

            # recognize type
            case connector.proxy.type
            when :video
              # create specific item
              item = Narra::Video.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
              # push specific metadata
              item.meta.new(name: 'type', value: :video, generator: :source)
            when :image
              # create specific item
              item = Narra::Image.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
              # push specific metadata
              item.meta.new(name: 'type', value: :image, generator: :source)
            when :audio
              # create specific item
              item = Narra::Audio.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
              # push specific metadata
              item.meta.new(name: 'type', value: :audio, generator: :source)
            when :text
              # create specific item
              item = Narra::Text.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
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
            item.meta.new(name: 'name', value: connector.proxy.name.downcase, generator: :source)
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
                    object.input = position[:in] if position[:in]
                    object.output = position[:out] if position[:out]
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
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('items#') { e.to_s }
          # throw
          raise e
        else
          # finish progress
          set_progress(1.0)
          # log
          logger.info('items#') { 'Items successfully created.' }
          # event done
          @event.done!
        end
      end

      def event
        @event
      end
    end
  end
end
