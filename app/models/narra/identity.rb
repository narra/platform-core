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
  class Identity
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :provider, type: String
    field :uid, type: String

    # User relations
    belongs_to :user, class_name: 'Narra::User'

    # Validations
    validates_uniqueness_of :uid, scope: :provider
    validates_presence_of :user_id, :uid, :provider

    # Find identity from the omniauth hash
    def self.find_from_hash(hash)
      Narra::Identity.where(provider: hash[:provider], uid: hash[:uid]).first
    end

    # Create a new identity from the omniauth hash
    def self.create_from_hash(hash, user = nil)
      user ||= Narra::User.create_from_hash!(hash)
      Narra::Identity.create(user: user, uid: hash[:uid], provider: hash[:provider])
    end
  end
end
