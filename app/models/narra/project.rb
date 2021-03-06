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
  class Project
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Meta
    include Narra::Extensions::Public
    include Narra::Extensions::Description
    include Narra::Extensions::Name

    # Fields
    field :_id, type: String
    field :thumbnails, type: Array, default: []

    # Meta Relations
    embeds_many :meta, inverse_of: :project, class_name: 'Narra::MetaProject'

    # User Relations
    belongs_to :author, inverse_of: :projects, class_name: 'Narra::User'
    has_and_belongs_to_many :contributors, inverse_of: :projects_contributions, class_name: 'Narra::User'

    # Library Relations
    has_and_belongs_to_many :libraries, inverse_of: :projects, index: true, class_name: 'Narra::Library'

    # Junction Relations
    has_many :junctions, autosave: true, dependent: :destroy, class_name: 'Narra::Junction'
    has_many :flows, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Flow'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Event'

    # Scenario Relations
    belongs_to :scenario, inverse_of: :projects, class_name: 'Narra::ScenarioProject'

    # Scopes
    scope :user, ->(user) { any_of({contributor_ids: user._id}, {author_id: user._id}) }

    # Validations
    validates_uniqueness_of :id
    validates_presence_of :id, :author_id, :scenario_id

    # Return all project items
    def items
      Narra::Item.libraries(self.library_ids)
    end

    # Return all author's sequences
    def sequences
      flows.where(_type: 'Narra::Sequence')
    end

    # Return all users paths
    def paths
      flows.where(_type: 'Narra::Path')
    end

    # Return as an array
    def models
      items
    end

    # Return this project for Meta extension
    def model
      self
    end

    # Static methods
    # Synthesize
    def self.synthesize(project, synthesizer, options = {})
      # Input check
      return if project.nil? || synthesizer.nil?

      # Submit synthesize process only if the project has the synthesizer enabled
      if project.scenario.synthesizers.collect { |synthesizer| synthesizer[:identifier].to_s }.include?(synthesizer.to_s)
        Narra::Core.synthesize(project, [synthesizer], options)
      end
    end
  end
end
