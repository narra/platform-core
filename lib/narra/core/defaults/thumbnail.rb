# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class Thumbnail < Narra::SPI::Default

        # Default values
        @identifier = :thumbnail

        def self.settings
          {
            thumbnail_extension: 'png',
            thumbnail_resolution: '350x250',
            thumbnail_count: '5',
            thumbnail_count_preview: '1'
          }
        end
      end
    end
  end
end
