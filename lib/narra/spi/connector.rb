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

      inheritable_attributes :identifier, :title, :description, :priority

      # Default values
      @identifier = :generic
      @title = 'Generic'
      @description = 'Generic Connector'
      @priority = 42

      # Generic constructor to store an item to be processed
      def initialize(url, options = {})
        @url = url
        @options = options
        # connector specific initialization
        initialization
      end

      #
      # Should be overridden and implemented
      #

      def source_url
        @url
      end

      def self.valid?(url)
        # Nothing to do
        # This has to be overridden in descendants
      end

      def self.resolve(url)
        # Nothing to do
        # This has to be overridden in descendants
      end

      def initialization
        # Nothing to do
        # This has to be overridden in descendants
      end

      def name
        # Nothing to do
        # This has to be overridden in descendants
      end

      def type
        # Nothing to do
        # This has to be overridden in descendants
      end

      def metadata
        # Nothing to do
        # This has to be overridden in descendants
      end

      def download_url
        # Nothing to do
        # This has to be overridden in descendants
      end
    end
  end
end