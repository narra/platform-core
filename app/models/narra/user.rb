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
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Tools::Logger

    # Fields
    field :username, type: String
    field :name, type: String
    field :email, type: String
    field :image, type: String
    field :roles, type: Array, default: []

    # Project Relations
    has_many :projects, autosave: true, inverse_of: :author, class_name: 'Narra::Project'
    has_and_belongs_to_many :projects_contributions, autosave: true, inverse_of: :contributors, class_name: 'Narra::Project'

    # Library Relations
    has_many :libraries, autosave: true, inverse_of: :author, class_name: 'Narra::Library'
    has_and_belongs_to_many :libraries_contributions, autosave: true, inverse_of: :contributors, class_name: 'Narra::Project'

    # Sequence Relations
    has_many :flows, autosave: true, inverse_of: :author, class_name: 'Narra::Flow'
    has_and_belongs_to_many :sequences_contributions, autosave: true, inverse_of: :contributors, class_name: 'Narra::Sequence'

    # Meta Relations
    has_many :meta, autosave: true, inverse_of: :author, class_name: 'Narra::Meta'

    # Meta Relations
    has_many :scenarios, autosave: true, inverse_of: :author, class_name: 'Narra::Scenario'

    # Identity Relations
    has_many :identities, dependent: :destroy, class_name: 'Narra::Identity'

    # ingest Relations
    has_many :ingests, dependent: :destroy, class_name: 'Narra::Ingest'

    # Validations
    validates_uniqueness_of :username

    # Hooks
    after_create :broadcast_events

    # Check if the user has certain role
    def is?(roles_check = [])
      !(roles & roles_check).empty?
    end

    # Return all user's paths
    def paths
      flows.where(_type: 'Narra::Path')
    end

    # Get all roles registered in the system
    def self.all_roles
      Narra::User.only(:roles).map(&:roles).reduce(:+).uniq
    end

    # Create a new user from the omniauth hash
    def self.create_from_hash!(hash)
      # create new user
      user = Narra::User.new(username: hash[:username], name: hash[:name], email: hash[:email], image: hash[:image])

      # assign default roles
      user.roles = (Narra::User.empty?) ? [:admin, :author] : [:author]

      # save
      return (user.save) ? user : nil
    end

    protected

    def broadcast_events
        broadcast(:narra_user_admin_created, {username: self.username}) if Narra::User.count == 1
    end
  end
end
