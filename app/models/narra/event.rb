# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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

    # user relation
    belongs_to :owner, autosave: true, inverse_of: :events, class_name: 'Narra::Auth::User'

    # Scopes
    scope :user, ->(user) { Narra::Event.or(
        { :owner_id.in => [user._id.to_s] },
        { :item_id.in => Narra::Item.user(user).pluck(:id) },
        { :library_id.in => Narra::Library.user(user).pluck(:id) },
        { :project_name.in => Narra::Project.user(user).pluck(:name) }
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
