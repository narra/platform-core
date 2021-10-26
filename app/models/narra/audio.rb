# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave/mongoid'

module Narra
  class Audio < Item

    # define audio proxy object / transcoding process
    mount_uploader :audio, Narra::AudioProxyUploader

    def prepared?
      !audio.url.nil?
    end
  end
end
