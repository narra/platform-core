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

require 'sidekiq-scheduler'
require 'narra/extensions'
require 'narra/tools'

module Narra
  module SPI
    # Generic template for scheduler
    class Scheduler
      include Sidekiq::Worker
      include Narra::Extensions::Class
      include Narra::Tools::Logger
      include Narra::Tools::InheritableAttributes

      inheritable_attributes :identifier, :name, :description, :interval

      # Default values
      @identifier = :generic
      @name = 'Generic'
      @description = 'Generic Scheduler'
      @interval = '10s'

      def perform
        # Nothing to do
        # This has to be overridden in descendants
      end
    end
  end
end
