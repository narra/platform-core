# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Export
        include Sidekiq::Worker

        sidekiq_options :queue => :export

        def perform(options)
          # check
          return if (options['project'].nil? && options['library'].nil?) || options['event'].nil? || options['return'].nil?
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
            # get return object
            return_object = Narra::Return.find(options['return'])
            # prepare data
            export_data = { metadata: object.meta.select { |meta| meta.public and meta.name != 'name' }.collect { |meta| { name: meta.name, value: meta.value } }.as_json }
            # save to file
            return_object.file = Narra::Tools::FileIO.new(export_data.to_json, "#{object.name.parameterize.underscore}.narra")
            # persiste
            return_object.save!
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'export')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("#{object.name} metadata successfully exported", 'export')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
