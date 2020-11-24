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

module Narra
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
              @object = "#{library._id.to_s}|#{library.name}"
              # fire event
              @event.run!
              # destroy library
              library.destroy
            when :ingest
                # fire event
                @event.run!
                # get timestamp
                timestamp = Time.parse(options['timestamp'])
                # log object
                @object = "older than #{options['timestamp']}"
                # get ingests older than said and destroy them
                Narra::Ingest.where(:created_at.lte => timestamp).each do |ingest|
                  # Destroy when it's not used
                  if ingest.items.empty?
                    logger.info('purge') { ingest.name }
                    ingest.destroy
                  end
                end
          end
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('purge#' + options['identifier'] + '#' + @object) { e.to_s }
          # throw
          raise e
        else
          # log
          logger.info('purge#' + options['identifier']) { options['identifier'].capitalize + " " + @object + ' successfully purged.' }
          # event done
          @event.done!
        end
      end
    end
  end
end
