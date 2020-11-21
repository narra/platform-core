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
  class Library
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Meta
    include Narra::Extensions::Shared

    # Fields
    field :name, type: String
    field :description, type: String
    field :purged, type: Boolean, default: false
    field :thumbnails, type: Array, default: []

    # Meta Relations
    embeds_many :meta, class_name: 'Narra::MetaLibrary'

    # User Relations
    belongs_to :author, inverse_of: :libraries, class_name: 'Narra::User'
    has_and_belongs_to_many :contributors, inverse_of: :libraries_contributions, class_name: 'Narra::User'

    # Item Relations
    has_many :items, autosave: true, dependent: :destroy, inverse_of: :library, class_name: 'Narra::Item'

    # Project Relations
    has_and_belongs_to_many :projects, inverse_of: :libraries, index: true, class_name: 'Narra::Project'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :library, class_name: 'Narra::Event'

    # Scenario Relations
    belongs_to :scenario, inverse_of: :libraries, class_name: 'Narra::ScenarioLibrary'

    # Scopes
    scope :user, ->(user) { any_of({contributor_ids:user._id}, {author_id: user._id}) }

    # Validations
    validates_uniqueness_of :name
    validates_presence_of :name, :author_id, :scenario_id

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
