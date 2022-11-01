# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Library
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Shared
    include Narra::Extensions::Description
    include Narra::Extensions::Name
    include Narra::Extensions::Meta
    include Narra::Extensions::Stats

    # Fields
    field :purged, type: Boolean, default: false
    field :thumbnails, type: Array, default: []

    # Meta Relations
    embeds_many :meta, class_name: 'Narra::MetaLibrary'

    # User Relations
    belongs_to :author, inverse_of: :libraries, class_name: 'Narra::Auth::User'
    has_and_belongs_to_many :contributors, inverse_of: :libraries_contributions, class_name: 'Narra::Auth::User'

    # Item Relations
    has_many :items, dependent: :destroy, inverse_of: :library, class_name: 'Narra::Item'

    # Project Relations
    has_and_belongs_to_many :projects, inverse_of: :libraries, index: true, class_name: 'Narra::Project'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :library, class_name: 'Narra::Event'

    # Scenario Relations
    belongs_to :scenario, inverse_of: :libraries, class_name: 'Narra::ScenarioLibrary'

    # Scopes
    scope :user, ->(user) { any_of({ contributor_ids: user._id }, { author_id: user._id }) }

    # Validations
    validates_presence_of :author_id, :scenario_id

    # Return as an array
    def models
      items
    end

    # Return this library for Meta extension
    def model
      self
    end

    # Check items for generated metadata
    def generate
      Narra::Item.generate(items)
    end
  end
end
