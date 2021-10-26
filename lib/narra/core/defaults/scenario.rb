# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class Scenario < Narra::SPI::Default

        # Default values
        @identifier = :scenario

        def self.listeners
          [
            {
              instance: Narra::Core::Defaults::Scenario.new,
              event: :narra_user_admin_created
            }
          ]
        end

        def narra_user_admin_created(options)
          # create default library and project scenarios
          # only when the first user is created as admin
          # this user become the author of these
          create_default_library_scenarios(options)
          create_default_project_scenarios(options)
        end

        private

        def create_default_project_scenarios(options)
          # create scenarion
          scenario = ScenarioProject.create({ author: Narra::Auth::User.find_by(email: options[:email]) })
          # update name and description
          scenario.name = "Empty project scenario"
          scenario.description = "Empty default scenario for projects"
          # make it shared
          scenario.shared = true
          # save
          scenario.save!
        end

        def create_default_library_scenarios(options)
          # create scenarion
          scenario = ScenarioLibrary.create({ author: Narra::Auth::User.find_by(email: options[:email]) })
          # update name and description
          scenario.name = "Empty library scenario"
          scenario.description = "Empty default scenario for libraries"
          # make it shared
          scenario.shared = true
          # save
          scenario.save!
        end
      end
    end
  end
end
