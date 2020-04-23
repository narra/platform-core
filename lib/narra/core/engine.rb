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

require 'narra/core'
require 'rails'

module Narra
  module Core
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/**/"]

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      end

      # Load all modules
      Dir["#{config.root}/lib/narra/generators/**/*.rb"].each do |file|
        require file
      end

      Dir["#{config.root}/lib/narra/synthesizers/**/*.rb"].each do |file|
        require file
      end

      Dir["#{config.root}/lib/narra/connectors/**/*.rb"].each do |file|
        require file
      end

      Dir["#{config.root}/lib/narra/transcoders/**/*.rb"].each do |file|
        require file
      end
    end
  end
end
