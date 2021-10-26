# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Purge

      # Purge library and its content
      def Core.purge_library(library_id)
        process(type: :purge, library: library_id, identifier: :library)
      end

      # Purge items
      def Core.purge_items(library_id: nil, items_ids: [])
        process(type: :purge, library: library_id, items: items_ids, identifier: :items)
      end

      # Purge ingests
      def Core.purge_ingests(timestamp)
        process(type: :purge, timestamp: timestamp, identifier: :ingest)
      end

      # Purge returns
      def Core.purge_returns(timestamp)
        process(type: :purge, timestamp: timestamp, identifier: :return)
      end
    end
  end
end
