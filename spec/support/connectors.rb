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

RSpec.configure do |config|
  config.before(:each) do
    # testing connector
    module Narra
      module Connectors
        class Testing < Narra::SPI::Connector
          # Set title and description fields
          @identifier = :testing
          @title = 'Testing'
          @description = 'Testing Connector'

          def self.valid?(url)
            url.end_with?('test')
          end

          def name
            'test_item'
          end

          def type
            :video
          end

          def metadata
            [
                {name: 'meta_03', value: 'Meta 03'},
                {name: 'meta_04', value: 'Meta 04'}
            ]
          end
        end
      end
    end
  end
end