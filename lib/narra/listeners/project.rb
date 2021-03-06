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
  module Listeners
    class Project
      include Narra::Tools::Logger

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
            log_info('Project ' + project._id + ' scenario updated.')
          end
        end
      end
    end
  end
end
