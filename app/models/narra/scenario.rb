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
  class Scenario
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Extensions::Meta
    include Narra::Extensions::Shared
    include Narra::Extensions::Name
    include Narra::Extensions::Description

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :scenario, class_name: 'Narra::MetaScenario'

    # User Relations
    belongs_to :author, inverse_of: :scenario, class_name: 'Narra::User'

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
