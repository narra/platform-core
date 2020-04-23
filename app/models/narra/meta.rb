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
  class Meta
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :name, type: String
    field :value, type: String
    field :hidden, type: Boolean, default: false
    field :public, type: Boolean, default: true

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :meta, class_name: 'Narra::User'

    # Validations
    validates_presence_of :name, :value
  end
end