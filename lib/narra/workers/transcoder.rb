#
# Copyright (C) 2020 narra.eu
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
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

require 'sidekiq'
require 'wisper'

module Narra
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
          logger.error('transcoder#' + options['identifier']) {e.message}
          logger.error('transcoder#' + options['identifier']) {e.backtrace.join("\n")}
          # throw
          raise e
        else
          # log
          logger.info('transcoder#' + options['identifier']) { 'Item ' + item.name + '#' + options['item'] + ' successfully transcoded.' }
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
