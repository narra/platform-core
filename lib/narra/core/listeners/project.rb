# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Listeners
      class Project < Narra::SPI::Listener

        # default values
        @identifier = :project
        @name = 'Project Actions'
        @description = 'Project Actions'
        # register events
        @events = [:narra_scenario_project_updated]

        # callbacks
        def narra_scenario_project_updated(options)
          options[:projects].each do |project_id|
            # get project and changes
            project = Narra::Project.find(project_id)
            changes = options[:changes]

            # process changes
            unless changes.nil?
              removed = changes - project.synthesizers
              created = project.synthesizers - changes

              # delete all junctions for appropriate synthesizer
              removed.each do |synthesizer|
                project.junctions.where(synthesizer: synthesizer).destroy_all
              end

              # run synthesize process for appropriate synthesizer
              created.each do |synthesizer|
                Narra::Project.synthesize(project, synthesizer[:identifier])
              end

              # log
              Narra::Core::LOGGER.log_info('Project ' + project._id + ' scenario updated.')
            end
          end
        end
      end
    end
  end
end
