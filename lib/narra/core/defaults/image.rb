# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class Image < Narra::SPI::Default

        # Default values
        @identifier = :image

        def self.settings
          {
            image_proxy_extension: 'png',
            image_proxy_lq_resolution: '320x180',
            image_proxy_hq_resolution: '1280x720'
          }
        end
      end
    end
  end
end
