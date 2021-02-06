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

require 'uri'
require 'narra/extensions'
require 'narra/tools'

module Narra
  module SPI
    # Generic template for generators
    class Connector
      include Narra::Extensions::Class
      include Narra::Tools::Logger
      include Narra::Tools::InheritableAttributes

      inheritable_attributes :identifier, :name, :description, :priority
      attr_reader :proxy, :metadata, :source_url, :download_url

      # Connector default values
      @identifier = :generic
      @name = 'Generic'
      @description = 'Generic Connector'
      @priority = 42

      # Generic constructor to store an item to be processed
      def initialize(proxy = Narra::Tools::Proxy.empty)
        @source_url = proxy.source_url
        @proxy = proxy
        @metadata = []
        # connector specific processing
        process
      end

      #
      # Should be overridden and implemented
      #

      def self.valid?(source_url)
        # Validates url if it's suitable for this connector
        # Nothing to do here
        # This has to be overridden in descendants
      end

      def self.resolve(source_url)
        # Resolves url for concrete items and create proxy items
        # This can processes multiple items
        # Nothing to do here
        # This has to be overridden in descendants
      end

      def process
        # Processes proxy item into regular one
        # This processes only one item
        # Nothing to do here
        # This has to be overridden in descendants
      end
    end
  end
end
