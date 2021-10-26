# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Import
        include Sidekiq::Worker

        sidekiq_options :queue => :import

        def perform(options)
          # check
          return if options['data'].nil? || options['event'].nil? || options['return'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # fire event
            @event.run!
            # get action class
            loaded = JSON.parse(File.read(options['data']))
            # check if the project exists
            project = Narra::Project.find(loaded["project"]["_id"])
            libraries = loaded["libraries"].collect { |library| Narra::Library.find(library["_id"]) }
            # firstly process libraries and overwrite with content
            libraries.each do |library|
              if library
                library.destroy!
              end
            end
            # delete project if exists
            if project
              project.destroy!
            end
            # objects to be persisted
            to_persist = []
            # create libraries
            loaded["libraries"].each do |library|
              to_persist << Narra::Library.new(library)
            end
            # create items
            loaded["items"].each do |item|
              to_persist << Narra::Text.new(item)
            end
            # create project
            to_persist << Narra::Project.new(loaded["project"])
            # persist
            to_persist.each do |object|
              object.save!
            end
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'import')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("Data successfully imported", 'import')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
