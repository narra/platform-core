# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class FFMPEG < Narra::SPI::Default

        # Default values
        @identifier = :ffmpeg

        def self.settings
          {
            ffmpeg_binary: '/usr/bin/ffmpeg',
            ffprobe_binary: '/usr/bin/ffprobe'
          }
        end
      end
    end
  end
end
