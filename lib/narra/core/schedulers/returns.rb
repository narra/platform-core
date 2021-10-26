# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Schedulers
      class Returns < Narra::SPI::Scheduler

        @identifier = :returns
        @name = 'Returns Purger'
        @description = 'It purges all returns older than 60 minutes every 60 minutes'
        @interval = '60m'

        def perform
          Narra::Core.purge_returns(60.minutes.ago.to_s)
        end
      end
    end
  end
end
