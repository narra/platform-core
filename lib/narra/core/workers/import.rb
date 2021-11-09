# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Import
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :import

        def perform(options)
          # check
          return if (options['project'].nil? && options['library'].nil?) || options['data'].nil? || options['event'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # fire event
            @event.run!
            # resolve object by type
            if options['project']
              # get project
              object = Narra::Project.find(options['project'])
            elsif options['library']
              # get library
              object = Narra::Library.find(options['library'])
            end
            # load data
            loaded = JSON.parse(options['data'], { symbolize_names: true })
            # create or update metadata
            loaded[:metadata].each_with_index do |meta, index|
              # check for existing meta
              m = object.get_meta(name: meta[:name])
              # update if does exist
              if m and meta[:value]
                object.update_meta(name: meta[:name], value: meta[:value])
              elsif meta[:name] and meta[:value]
                # add new one
                object.add_meta(name: meta[:name], value: meta[:value])
              end
              # update progress
              set_progress(loaded[:metadata].count / (index + 1))
            end
            # progress done, just to be sure we're ending up at 1
            set_progress(1.0)
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'import')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("#{object.name} metadata successfully imported", 'import')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
