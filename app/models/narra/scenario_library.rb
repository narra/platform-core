# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class ScenarioLibrary < Scenario

    # Fields
    field :generators, type: Array, default: []

    # Relations
    has_many :libraries, class_name: 'Narra::Library'

    # Validations
    validates_uniqueness_of :name

    protected

    def broadcast_events
      broadcast(:narra_scenario_library_updated, {libraries: libraries.collect {|library| library._id}}) if self.generators_changed?
    end
  end
end
