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
