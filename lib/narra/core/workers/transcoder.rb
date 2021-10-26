# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'
require 'wisper'

module Narra
  module Core
    module Workers
      class Transcoder
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :transcodes

        def perform(options)
          # check
          return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?
          # transcode
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # get item
            item = Narra::Item.find(options['item'])
            # fire event
            @event.run!
            # create listener
            listener = Narra::Listeners::Transcoder.new
            # push event
            listener.event = @event
            # Prepare file for transcode
            if item.ingest
              # It's already downloaded and cached as the ingest
              temporary = item.ingest
            else
              # It has to be downloaded
              # - not using remote_{key}_url method as a workaround
              #   to an issue when after save the key was still nil
              # - it's not ideal but works for now
              temporary = CarrierWave::SanitizedFile.new(CarrierWave::Downloader::Base.new(nil).download(options['identifier'], {}))
            end
            # Temporary subscribe listener
            Wisper.subscribe(listener) do
              # process transcoder
              item.send("#{item.type}=".to_sym, temporary.file)
            end
            # save item
            item.save!
            # finish progress
            set_progress(1.0)
          rescue => e
            # reset event
            @event.reset!
            # log
            Narra::Core::LOGGER.log_error(e.message, 'transcoder')
            Narra::Core::LOGGER.log_error(e.backtrace.join("\n"), 'transcoder')
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("Item #{item.name}##{options['item']} successfully transcoded", 'transcoder')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
