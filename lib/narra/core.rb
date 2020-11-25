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
require 'narra/spi'
require 'narra/defaults'
require 'narra/storages'
require 'narra/workers'
require 'narra/transcoders'
require 'narra/schedulers'

require 'narra/core/engine'
require 'narra/core/version'

require 'narra/core/connectors'
require 'narra/core/generators'
require 'narra/core/synthesizers'
require 'narra/core/items'
require 'narra/core/sequences'
require 'narra/core/purge'

module Narra
  module Core
    include Narra::Core::Connectors
    include Narra::Core::Generators
    include Narra::Core::Synthesizers
    include Narra::Core::Items
    include Narra::Core::Sequences
    include Narra::Core::Purge

    private

    def self.process(options)
      # setup message
      message = 'narra::' + options[:type].to_s + '::'
      message += options[:item] unless options[:item].nil?
      message += options[:project] unless options[:project].nil?
      message += options[:library] unless options[:library].nil?
      message += '::' + options[:identifier].to_s unless options[:type] == :transcoder
      # create an event
      event = Narra::Event.create!(message: message,
                                  item: options[:item].nil? ? nil : Narra::Item.find(options[:item]),
                                  project: options[:project].nil? ? nil : Narra::Project.find(options[:project]),
                                  library: options[:library].nil? ? nil : Narra::Library.find(options[:library]),
                                  broadcasts: ['narra_' + options[:type].to_s + '_done'])

      # process
      case options[:type]
        when :transcoder
          Narra::Workers::Transcoder.perform_async(options.merge({event: event._id.to_s}))
        when :generator
          Narra::Workers::Generator.perform_async(options.merge({event: event._id.to_s}))
        when :synthesizer
          Narra::Workers::Synthesizer.perform_async(options.merge({event: event._id.to_s}))
        when :purge
          Narra::Workers::Purge.perform_async(options.merge({event: event._id.to_s}))
      end

      # return event
      return event
    end
  end
end
