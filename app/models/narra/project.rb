# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/extensions'

module Narra
  class Project
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Public
    include Narra::Extensions::Description
    include Narra::Extensions::Name
    include Narra::Extensions::Meta

    # Fields
    field :identifier, type: String
    field :thumbnails, type: Array, default: []

    # Meta Relations
    embeds_many :meta, inverse_of: :project, class_name: 'Narra::MetaProject'

    # User Relations
    belongs_to :author, inverse_of: :projects, class_name: 'Narra::Auth::User'
    has_and_belongs_to_many :contributors, inverse_of: :projects_contributions, class_name: 'Narra::Auth::User'

    # Library Relations
    has_and_belongs_to_many :libraries, inverse_of: :projects, index: true, class_name: 'Narra::Library'

    # Junction Relations
    has_many :junctions, autosave: true, dependent: :destroy, class_name: 'Narra::Junction'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Event'

    # Scenario Relations
    belongs_to :scenario, inverse_of: :projects, class_name: 'Narra::ScenarioProject'

    # Scopes
    scope :user, ->(user) { any_of({contributor_ids: user._id}, {author_id: user._id}) }

    # Validations
    validates_uniqueness_of :identifier
    validates_presence_of :identifier, :author_id, :scenario_id

    # Return all project items
    def items
      Narra::Item.libraries(self.library_ids)
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
