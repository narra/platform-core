# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Junction
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :weight, type: Float
    field :synthesizer, type: Symbol
    field :sources, type: Array, default: []
    field :direction, type: Hash, default: {none: true}

    # Project relation
    belongs_to :project, index: true, class_name: 'Narra::Project'

    # Item Relations
    has_and_belongs_to_many :items, index: true, class_name: 'Narra::Item'

    # Validations
    validates_uniqueness_of :project, scope: [:synthesizer, :direction, :item_ids]
    validates_presence_of :weight, :synthesizer, :project, :items

    # Scopes
    scope :project, ->(project) { where(project: project) }
    scope :synthesizer, ->(synthesizer) { where(synthesizer: synthesizer) }
  end
end
