# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class MetaScenario < Meta
    # Relations
    belongs_to :scenario, inverse_of: :meta, class_name: 'Narra::Scenario'

    # Validations
    validates_uniqueness_of :name, :scope => [:scenario_id]
  end
end
