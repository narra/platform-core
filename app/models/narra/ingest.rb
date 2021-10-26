# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Ingest
    include Mongoid::Document
    include Mongoid::Timestamps

    # fields
    field :name, type: String

    # define ingest file object
    mount_uploader :file, Narra::IngestUploader

    # item relation
    has_many :items, class_name: 'Narra::Item'
  end
end
