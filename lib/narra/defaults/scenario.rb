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

module Narra
  module Defaults
    class Scenario < Narra::SPI::Default

      # Default values
      @identifier = :scenario

      def self.listeners
        [
            {
                instance: Narra::Defaults::Scenario.new,
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
        scenario = ScenarioProject.create({name: "Empty project scenario", description: "Empty default scenario for projects", author: User.find_by(username: options[:username])})
        # make it shared
        scenario.shared = true
        # save
        scenario.save!
      end

      def create_default_library_scenarios(options)
        # create scenarion
        scenario = ScenarioLibrary.create({name: "Empty library scenario", description: "Empty default scenario for libraries", author: User.find_by(username: options[:username])})
        # make it shared
        scenario.shared = true
        # save
        scenario.save!
      end
    end
  end
end
