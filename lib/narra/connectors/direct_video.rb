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

module Narra
  module Connectors
    class DirectVideo < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :direct_video
      @title = 'Direct Video Connector'
      @description = 'Direct Video Connector uses direct http links to files'
      @priority = 0

      def self.valid?(source_url)
        source_url.start_with?('http://') and (source_url.end_with?('.webm') or source_url.end_with?('.mp4') or source_url.end_with?('.mov'))
      end

      def self.resolve(source_url)
        download_url = URI.parse(source_url)
        name = URI.decode(File.basename(download_url.path).split('.').first)

        # return proxies
        [Narra::Tools::Proxy.default(name, :video, source_url, download_url, @identifier, [], {library:'Super Test'})]
      end

      def process
        # set up
        @download_url = @proxy.download_url
      end
    end
  end
end
