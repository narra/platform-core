# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class Video < Narra::SPI::Default

        # Default values
        @identifier = :video

        def self.settings
          {
            video_proxy_extension: 'mp4',
            video_proxy_lq_resolution: '320x180',
            video_proxy_lq_bitrate: '300',
            video_proxy_hq_resolution: '1280x720',
            video_proxy_hq_bitrate: '1000',
          }
        end
      end
    end
  end
end
