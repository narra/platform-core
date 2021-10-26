# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Scenario
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Extensions::Shared
    include Narra::Extensions::Name
    include Narra::Extensions::Description
    include Narra::Extensions::Meta

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :scenario, class_name: 'Narra::MetaScenario'

    # User Relations
    belongs_to :author, inverse_of: :scenario, class_name: 'Narra::Auth::User'

    # Hooks
    after_update :broadcast_events

    def type
      _type.split('::').last.downcase.sub('scenario', '').to_sym
    end

    def models
      [self]
    end

    def model
      self
    end
  end
end
