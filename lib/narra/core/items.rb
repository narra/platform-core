# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
