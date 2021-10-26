# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Actions

      # Return all active connectors
      def Core.actions
        # Get all descendants of the Generic generator
        @actions ||= Narra::SPI::Action.descendants.sort { |x, y| x.priority.to_i <=> y.priority.to_i }
      end

      # Return specified connector
      def Core.action(identifier)
        actions.select { |action| action.identifier.equal?(identifier.to_sym) }.first
      end

      def Core.perform(items, action, user_id, returns: [], options: {})
        process(type: :action, identifier: action, items: items, returns: returns, options: options, user: user_id)
      end

      private

      # Return all active connectors
      def self.actions_identifiers
        # Get array of synthesizers identifiers
        @actions_identifiers ||= actions.collect { |action| action.identifier }
      end
    end
  end
end
