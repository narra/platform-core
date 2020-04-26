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
    class DirectAudio < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :direct_audio
      @title = 'Direct Audio Connector'
      @description = 'Direct Audio Connector uses direct http links to files'
      @priority = 0

      def self.valid?(url)
        url.start_with?('http://') and (url.end_with?('.wav') or url.end_with?('.mp3') or url.end_with?('.ogg') or url.end_with?('.flac') or url.end_with?('.m4a') or url.end_with?('.aiff'))
      end

      def self.resolve(url)
        uri = URI.parse(url)
        name = File.basename(uri.path).split('.').first

        # return proxies
        [{
             url: url,
             name: name,
             thumbnail: nil,
             type: :audio,
             connector: @identifier,
             @identifier => {
                 type: :audio,
                 name: name
             }
         }]
      end

      def name
        @options[:name]
      end

      def type
        :audio
      end

      def metadata
        []
      end

      def download_url
        @url
      end
    end
  end
end