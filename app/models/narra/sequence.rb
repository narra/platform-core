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
  class Sequence < Flow
    include Wisper::Publisher
    include Narra::Extensions::Meta
    include Narra::Extensions::Public

    # Fields
    field :description, type: String
    field :fps, type: Float
    field :prepared, type: Boolean, default: false

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :sequence, class_name: 'Narra::MetaSequence'

    # User Relations
    has_and_belongs_to_many :contributors, inverse_of: :sequences_contributions, class_name: 'Narra::User'

    # Item Relations
    has_one :master, class_name: 'Narra::Item'

    # Callbacks
    after_destroy :broadcast_events_destroyed
    after_create :broadcast_events_created

    # Return this sequence for Meta extension
    def model
      self
    end

    def prepared?
      # This has to be overridden in descendants
      prepared
    end
    
    protected

    def broadcast_events_destroyed
      broadcast(:narra_sequence_destroyed, {project: self.project.name, sequence: self._id.to_s})
    end

    def broadcast_events_created
      # broadcast all events
      broadcast(:narra_sequence_created, {project: self.project.name, sequence: self._id.to_s})
    end
  end
end
