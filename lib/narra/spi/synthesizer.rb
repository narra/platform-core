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

require 'narra/extensions'
require 'narra/tools'

module Narra
  module SPI
    # Generic template for synthesizers
    class Synthesizer
      include Narra::Extensions::Class
      include Narra::Extensions::Junction
      include Narra::Extensions::Options
      include Narra::Extensions::Progress
      include Narra::Tools::Logger
      include Narra::Tools::InheritableAttributes

      inheritable_attributes :identifier, :title, :description, :options, :dependency, :priority

      # Default values
      @identifier = :generic
      @name = 'Generic'
      @description = 'Generic Synthesizer'
      @options = {}
      @dependency = []
      @priority = 42

      # Generic constructor to store an item to be processed
      def initialize(project, event)
        @project = project
        @event = event
      end

      def model
        @project
      end

      def event
        @event
      end

      #
      # Should be overridden and implemented
      #

      def self.valid?(project_to_check)
        # Nothing to do
        # This has to be overridden in descendants
      end

      def synthesize(options = {})
        # Nothing to do
        # This has to be overridden in descendants
      end

      def self.listeners
        # Nothing to do
        # This can be overridden in descendants
        # It should return array of listener hashes
        # {
        #   instance: Narra::Synthesizers::Generic::Listener.new,
        #   event: :narra_generic_event
        # }
        []
      end
    end
  end
end
