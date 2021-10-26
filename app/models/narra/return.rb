# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Return
    include Mongoid::Document
    include Mongoid::Timestamps

    # define ingest file object
    mount_uploader :file, Narra::ReturnUploader

    # User relations
    belongs_to :user, class_name: 'Narra::Auth::User'
  end
end
