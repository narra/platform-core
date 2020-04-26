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

require 'aasm'
require 'sidekiq/api'

module Narra
  class Event
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include AASM

    # fields
    field :message, type: String
    field :status, type: Symbol
    field :progress, type: Float, default: 0.0
    field :broadcasts, type: Array, default: []

    # item relation
    belongs_to :item, autosave: true, inverse_of: :events, class_name: 'Narra::Item'

    # project relation
    belongs_to :project, autosave: true, inverse_of: :events, class_name: 'Narra::Project'

    # project relation
    belongs_to :library, autosave: true, inverse_of: :events, class_name: 'Narra::Library'

    # Scopes
    scope :user, ->(user) { Event.or(
        { :item_id.in => Item.user(user).pluck(:id) },
        { :library_id.in => Library.user(user).pluck(:id) },
        { :project_name.in => Project.user(user).pluck(:name) }
    )}

    # callbacks
    before_destroy :broadcast_events

    aasm :column => :status, :skip_validation_on_save => true do
      state :pending, :initial => true
      state :running
      state :done

      event :run do
        transitions :to => :running, :from => [:pending]
      end

      event :reset, after: Proc.new { set_progress(0.0) } do
        transitions :to => :pending, :from => [:running]
      end

      event :done, after: Proc.new { self.destroy } do
        transitions :to => :done, :from => [:running]
      end
    end

    def set_progress(number)
      update_attribute(:progress, number)
    end

    protected

    def broadcast_events
      broadcasts.each do |broadcast|
        broadcast(broadcast.to_sym, {item: (item.nil? ? nil : item._id.to_s), project: (project.nil? ? nil : project._id.to_s)})
      end
    end
  end
end
