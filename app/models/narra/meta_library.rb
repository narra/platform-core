# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class MetaLibrary < Meta
    # Relations
    embedded_in :library, inverse_of: :meta, class_name: 'Narra::Library'

    # Validations
    validates_uniqueness_of :name, :scope => [:library_id]
  end
end
