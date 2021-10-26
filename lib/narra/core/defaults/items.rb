# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Defaults
      class Items < Narra::SPI::Default

        # Default values
        @identifier = :items

        def self.settings
          {
            items_probe_interval: 1.minute.to_s
          }
        end
      end
    end
  end
end
