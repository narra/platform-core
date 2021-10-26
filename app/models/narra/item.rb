# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Item
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Meta

    # Fields
    field :name, type: String
    field :url, type: String
    field :connector, type: String
    field :thumbnails, type: Array, default: []

    # Library Relations
    belongs_to :library, class_name: 'Narra::Library'

    # Ingest Relations
    belongs_to :ingest, class_name: 'Narra::Ingest'

    # Meta Relations
    embeds_many :meta, inverse_of: :item, class_name: 'Narra::MetaItem'

    # Junction Relations
    has_and_belongs_to_many :junctions, autosave: true, dependent: :destroy, class_name: 'Narra::Junction'

    # Event Relations
    has_many :events, dependent: :destroy, class_name: 'Narra::Event'

    # Thumbnail Relations
    has_many :_thumbnails, autosave: true, dependent: :destroy, class_name: 'Narra::Thumbnail'

    # Validations
    validates_uniqueness_of :name, scope: :library_id
    validates_presence_of :name, :url

    # Scopes
    scope :user, ->(user) { any_in(library_id: Library.user(user).pluck(:id)) }
    scope :libraries, ->(libraries) { any_in(library_id: libraries) }

    # Return as an array
    def models
      [self]
    end

    def model
      self
    end

    def type
      _type.split('::').last.downcase.to_sym
    end

    def prepared?
      # This has to be overridden in descendants
      return false
    end

    def generate
      Narra::Item.generate([self])
    end

    # Static methods
    # Check items for generated metadata
    def self.generate(input_items = nil)
      # resolve items
      items = input_items.nil? ? Narra::Item.all : input_items

      # run generator process for those where exact generator wasn't executed
      items.each do |item|
        item.library.scenario.generators.each do |generator|
          Narra::Core.generate(item, [generator[:identifier]]) if Narra::MetaItem.where(item: item).generators([generator[:identifier]], false).empty?
        end
      end
    end
  end
end
