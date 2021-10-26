# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'fog/aws'

module Narra
  module Core
    module Storages
      class AWS < Narra::SPI::Storage

        # Default values
        @identifier = :aws
        @name = 'Amazon AWS Storage'
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
end
