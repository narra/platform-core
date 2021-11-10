# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/extensions'
require 'narra/tools'
require 'narra/spi'

require_relative 'core/logger'
require_relative 'core/engine'
require_relative 'core/version'

require_relative 'core/storages'
require_relative 'core/listeners'
require_relative 'core/defaults'
require_relative 'core/schedulers'
require_relative 'core/workers'
require_relative 'core/transcoders'
require_relative 'core/connectors'
require_relative 'core/generators'
require_relative 'core/synthesizers'
require_relative 'core/actions'
require_relative 'core/items'
require_relative 'core/purge'
require_relative 'core/export'
require_relative 'core/import'
require_relative 'core/copy'

module Narra
  module Core

    include Narra::Core::Connectors
    include Narra::Core::Generators
    include Narra::Core::Synthesizers
    include Narra::Core::Actions
    include Narra::Core::Items
    include Narra::Core::Purge
    include Narra::Core::Export
    include Narra::Core::Import
    include Narra::Core::Copy

    private

    def self.process(options)
      # setup message
      message = "narra::#{options[:type].to_s}"
      message += "::#{options[:item]}" unless options[:item].nil?
      message += "::#{options[:project]}" unless options[:project].nil?
      message += "::#{options[:library]}" unless options[:library].nil?
      message += "::#{options[:user]}" unless options[:user].nil?
      message += "::#{options[:identifier].to_s}" unless options[:identifier].nil?
      # create an event
      event = Narra::Event.create!(message: message,
                                   item: options[:item].nil? ? nil : Narra::Item.find(options[:item]),
                                   project: options[:project].nil? ? nil : Narra::Project.find(options[:project]),
                                   library: options[:library].nil? ? nil : Narra::Library.find(options[:library]),
                                   owner: options[:user].nil? ? nil : Narra::Auth::User.find(options[:user]),
                                   broadcasts: ['narra_' + options[:type].to_s + '_done'])
      # update options
      options.merge!({ event: event._id.to_s })
      # get worker class object and process
      Narra::Extensions::Class.class_from_string("Narra::Core::Workers::#{options[:type].to_s.capitalize}").perform_async(options)
      # return event
      return event
    end
  end
end
