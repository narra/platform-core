# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class ScenarioProject < Scenario

    # Fields
    field :synthesizers, type: Array, default: []

    # Relations
    has_many :projects, inverse_of: :scenario, class_name: 'Narra::Project'

    # Validations
    validates_uniqueness_of :name

    protected

    def broadcast_events
      broadcast(:narra_scenario_project_updated, {projects: projects.collect {|project| project.name}, changes: self.changed_attributes['synthesizers']}) if self.synthesizers_changed?
    end
  end
end
