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
  module Storages
    class Local < Narra::SPI::Storage

      # Default values
      @identifier = :local
      @name = 'Local Storage'
      @description = 'Central storage with minio accessor'

      def initialization(config)
        config.storage = :fog
        config.fog_provider = 'fog/aws'
        config.fog_credentials = {
            provider: 'AWS',
            aws_access_key_id: ENV['MINIO_ACCESS_KEY'],
            aws_secret_access_key: ENV['MINIO_SECRET_KEY'],
            region: 'us-east-1',
            host: 'storage',
            endpoint: "http://#{(ENV['NARRA_STORAGE_HOSTNAME'] ||= 'test')}",
            path_style: true
        }
        config.fog_directory  = 'narra'
      end
    end
  end
end
