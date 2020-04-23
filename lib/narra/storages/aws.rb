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

require 'fog/aws'

module Narra
  module Storages
    class AWS < Narra::SPI::Storage

      # Default values
      @identifier = :aws
      @title = 'Amazon AWS Storage'
      @description = 'Central storage with cloud accessor'
      @requirements = ['AWS_ACCESS_KEY', 'AWS_SECRET', 'AWS_REGION', 'AWS_BUCKET']

      def initialization(config)
        config.storage = :fog
        config.fog_provider = 'fog/aws'
        config.fog_credentials = {
            provider: 'AWS',
            aws_access_key_id: ENV['AWS_ACCESS_KEY'],
            aws_secret_access_key: ENV['AWS_SECRET'],
            region: ENV['AWS_REGION'],
        }
        config.fog_directory = ENV['AWS_BUCKET']
        config.cache_dir = Narra::Tools::Settings.storage_temp
      end
    end
  end
end