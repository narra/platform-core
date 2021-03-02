#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

module Narra
  module Core
    module Items

      include ActionView::Helpers::TextHelper

      # Check item for connector and return back
      def Core.check_item(source_url)
        # input check
        return nil if source_url.nil?

        # connector proxies container
        proxies = []

        # parse url for proper connector
        connectors.each do |conn|
          if conn.valid?(source_url)
            proxies = conn.resolve(source_url)
            # break the loop
            break
          end
        end

        # return
        return proxies
      end

      # Add items into the NARRA
      def Core.add_items(proxies, library_id, user_id)
        # input check
        return nil if user_id.nil? || library_id.nil? || proxies.nil? || proxies.empty?
        # process async
        process(type: :items, proxies: proxies, library: library_id, user: user_id)
      end
    end
  end
end
