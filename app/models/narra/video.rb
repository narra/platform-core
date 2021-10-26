# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave/mongoid'

module Narra
  class Video < Item

    # define video proxy object / transcoding process
    mount_uploader :video, Narra::VideoProxyUploader

    # overriding to check whether the video is prepared
    def prepared?
      !video.url.nil? && !video.lq.url.nil? && !video.audio.url.nil?
    end
  end
end
