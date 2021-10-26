# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Schedulers
      class Indexes < Narra::SPI::Scheduler

        @identifier = :indexes
        @name = 'Database Indexer'
        @description = 'Creating database indexes'
        @interval = '60m'

        def perform
          Narra::Item.create_indexes
          Narra::Library.create_indexes
          Narra::Project.create_indexes
        end
      end
    end
  end
end
