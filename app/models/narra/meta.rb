# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Meta
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :name, type: String
    field :value, type: String
    field :hidden, type: Boolean, default: false
    field :public, type: Boolean, default: true

    # Validations
    validates_presence_of :name
  end
end
