# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class MetaItem < Meta
    # Generator
    field :generator, type: Symbol

    # In / Out
    field :input, type: Float
    field :output, type: Float

    # Relations
    embedded_in :item, inverse_of: :meta, class_name: 'Narra::Item'

    # Validations
    validates_uniqueness_of :name, :scope => [:generator, :item_id]
    validates_presence_of :generator

    # Scopes
    scope :generators, ->(generators, source = true) { any_in(generator: source ? (generators | [:source]) : generators) }
  end
end
