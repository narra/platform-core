# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Copy
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :copy

        def perform(options)
          # check
          return if (options['project'].nil? && options['library'].nil?) || options['event'].nil? || options['destination'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # fire event
            @event.run!
            # resolve object by type
            if options['project']
              # get project
              source_object = Narra::Project.find(options['project'])
              destination_object = Narra::Project.find(options['destination'])
            elsif options['library']
              # get library
              source_object = Narra::Library.find(options['library'])
              destination_object = Narra::Library.find(options['destination'])
            end
            # prepare data
            data = source_object.meta.select { |meta| meta.public and meta.name != 'name' }.collect { |meta| { name: meta.name, value: meta.value } }
            # copy data and overwrite
            data.each_with_index do |meta, index|
              # check for existing meta
              m = destination_object.get_meta(name: meta[:name])
              # update if does exist
              if m and meta[:value]
                destination_object.update_meta(name: meta[:name], value: meta[:value])
              elsif meta[:name] and meta[:value]
                # add new one
                destination_object.add_meta(name: meta[:name], value: meta[:value])
              end
              # update progress
              set_progress(data.count / (index + 1))
            end
            # progress done, just to be sure we're ending up at 1
            set_progress(1.0)
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'copy')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("#{source_object.name} metadata successfully copied to #{destination_object.name}", 'copy')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
