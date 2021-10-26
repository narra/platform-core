# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Purge
        include Sidekiq::Worker

        sidekiq_options :queue => :purge

        def perform(options)
          # check
          return if options['identifier'].nil? || options['event'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # get identifier
            identifier = options['identifier'].to_sym
            case identifier
            when :library
              # get library
              library = Narra::Library.find(options['library'])
              # log object
              @object = "Library #{library._id.to_s} | #{library.name}"
              # fire event
              @event.run!
              # destroy library
              library.destroy
            when :ingest
              # get timestamp
              timestamp = Time.parse(options['timestamp'])
              # log object
              @object = "Ingests older than #{options['timestamp']}"
              # fire event
              @event.run!
              # get ingests older than said and destroy them
              Narra::Ingest.where(:created_at.lte => timestamp).each do |ingest|
                # Destroy when it's not used
                if ingest.items.empty?
                  # destroy
                  ingest.destroy
                end
              end
            when :return
              # get timestamp
              timestamp = Time.parse(options['timestamp'])
              # log object
              @object = "Returns older than #{options['timestamp']}"
              # fire event
              @event.run!
              # get ingests older than said and destroy them
              Narra::Return.where(:created_at.lte => timestamp).each do |r|
                # destroy return
                r.destroy
              end
            when :items
              # items array
              items = options['items']
              # check for library
              if options['library']
                # resolve
                library = Narra::Library.find(options['library'])
                # update items array to purge
                items = items.concat(library.item_ids)
              end
              # log object
              @object = "Selected items"
              @object += " and all from library #{library.name}" if library
              # fire event
              @event.run!
              # iterate through items
              Narra::Item.any_in(_id: items).each do |item|
                # destroy iten
                item.destroy
              end
            end
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'purge')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("#{@object} successfully purged", 'purge')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
