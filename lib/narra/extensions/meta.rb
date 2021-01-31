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

module Narra
  module Extensions
    module Meta

      def autosave
        true
      end

      def add_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # check generator
        if options[:generator].nil? && model.kind_of?(Narra::Item)
          if self.kind_of?(Narra::SPI::Generator)
            options[:generator] = self.class.identifier
          else
            return
          end
        end
        # create meta if model supports
        if model.respond_to?('meta')
          meta = model.meta.new(options)
          # autosave
          model.save if autosave
          # return new meta
          return meta
        end
        # return nil
        return
      end

      def update_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # retrieve meta
        meta = get_meta(name: options[:name], generator: options[:generator])
        # update value when the meta is founded
        unless meta.nil?
          meta.update_attributes(value: options[:value])
          # check for new generator field
          meta.update_attributes(generator: options[:new_generator]) unless options[:new_generator].nil?
        end
        # return meta
        meta
      end

      def get_meta(options)
        # do a query
        Meta.get_meta(model, options)
      end

      def self.get_meta(model, options)
        # check for model
        return nil if model.nil? and !model.respond_to?('meta')
        # do a query
        model.meta.find_by(options)
      end
    end
  end
end
