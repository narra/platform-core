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

# It serves as a proxy object during item creation
module Narra
  module Tools
    class Proxy
      # Define attributes
      attr_accessor :name, :type, :source_url, :download_url, :connector, :thumbnails, :options
      # Constructor
      def initialize(name, type, source_url, download_url, connector, thumbnails, options)
        @name = name
        @type = type
        @source_url = source_url
        @download_url = download_url
        @connector = connector
        @thumbnails = thumbnails
        @options = options
      end

      # Default factories
      # Empty proxy object
      def self.empty()
        Narra::Tools::Proxy.new('', :empty, '', '', :generic, [], {})
      end

      # Simple proxy object
      def self.default(name, type, source_url, download_url, connector, thumbnails = [], options = {})
        Narra::Tools::Proxy.new(name, type, source_url, download_url, connector, thumbnails, options)
      end

      # Parse from hash object
      def self.parse(hash)
        Narra::Tools::Proxy.new(hash[:name], hash[:type].to_sym, hash[:source_url], hash[:download_url], hash[:connector].to_sym, hash[:thumbnails], hash[:options])
      end
    end
  end
end
