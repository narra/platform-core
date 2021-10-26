# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
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
            aws_access_key_id: ENV['MINIO_ROOT_USER'],
            aws_secret_access_key: ENV['MINIO_ROOT_PASSWORD'],
            region: 'us-east-1',
            host: 'http://storage:9000',
            endpoint: "http://#{(ENV['NARRA_STORAGE_HOSTNAME'] ||= 'test')}",
            path_style: true
          }
          config.fog_directory = 'narra'
        end
      end
    end
  end
end
