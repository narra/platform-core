# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class MetaProject < Meta
    # Relations
    embedded_in :project, inverse_of: :meta, class_name: 'Narra::Project'

    # Validations
    validates_uniqueness_of :name, :scope => [:project_id]
  end
end
