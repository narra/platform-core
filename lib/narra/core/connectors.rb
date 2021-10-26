# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Connectors

      # Return all active connectors
      def Core.connectors
        # Get all descendants of the Generic generator
        @connectors ||= Narra::SPI::Connector.descendants.sort {|x,y| x.priority.to_i <=> y.priority.to_i }
      end

      # Return specified connector
      def Core.connector(identifier)
        connectors.select { |connector| connector.identifier.equal?(identifier.to_sym)}.first
      end

      private

      # Return all active connectors
      def self.connectors_identifiers
        # Get array of synthesizers identifiers
        @connectors_identifiers ||= connectors.collect { |connector| connector.identifier }
      end
    end
  end
end
