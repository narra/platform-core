# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave/mongoid'

module Narra
  class Thumbnail
    include Mongoid::Document
    include Mongoid::Timestamps

    field :random, type: Float, default: Proc.new { Random.rand }

    belongs_to :item, inverse_of: :_thumbnails, class_name: 'Narra::Item'

    mount_uploader :file, Narra::ThumbnailUploader
  end
end
