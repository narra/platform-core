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
  module Core
    module Items

      include ActionView::Helpers::TextHelper

      # Check item for connector and return back
      def Core.check_item(source_url)
        # input check
        return nil if source_url.nil?

        # connector proxies container
        proxies = []

        # parse url for proper connector
        connectors.each do |conn|
          if conn.valid?(source_url)
            proxies = conn.resolve(source_url)
            # break the loop
            break
          end
        end

        # return
        return proxies
      end

      # Add item into the NARRA
      def Core.add_item(proxy, library, user)
        # input check
        return nil if user.nil? || library.nil? || proxy.nil? || connector(proxy.connector).nil?

        # connector container
        connector = connector(proxy.connector).new(proxy)

        # item container
        item = nil

        # recognize type
        case connector.proxy.type
        when :video
          # create specific item
          item = Narra::Video.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
          # push specific metadata
          item.meta.new(name: 'type', value: :video, generator: :source)
        when :image
          # create specific item
          item = Narra::Image.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
          # push specific metadata
          item.meta.new(name: 'type', value: :image, generator: :source)
        when :audio
          # create specific item
          item = Narra::Audio.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
          # push specific metadata
          item.meta.new(name: 'type', value: :audio, generator: :source)
        when :text
          # create specific item
          item = Narra::Text.new(name: connector.proxy.name.downcase, url: connector.proxy.source_url, library: library)
          # push specific metadata
          item.meta.new(name: 'type', value: :text, generator: :source)
        end

        # # save ingest if exist
        if item.url.include?(ENV['NARRA_STORAGE_HOSTNAME'])
          # get ingest id
          match = item.url.match(/.*ingest\/(?<ingest>.*)\/.*/)
          # find ingest
          ingest = Narra::Ingest.find(match[:ingest])
          # check and save
          if ingest
            item.ingest = ingest
          end
        end

        # create source metadata from essential fields
        item.meta.new(name: 'name', value: connector.proxy.name.downcase, generator: :source)
        item.meta.new(name: 'url', value: item.url, generator: :source)
        item.meta.new(name: 'library', value: library.name, generator: :source)
        item.meta.new(name: 'connector', value: connector.proxy.connector.to_s, generator: :source)

        # parse metadata from connector if exists
        connector.metadata.each do |meta|
          if !meta[:name].nil? and !meta[:value].nil?
            # empty marks
            object = item.meta.new(name: meta[:name], value: meta[:value], generator: connector.proxy.connector.to_s)
            # check for marks
            if !meta[:positions].nil? and !meta[:positions].empty?
              meta[:positions].each do |position|
                object.input = position.to_f
              end
            end
          end
        end

        # parse metadata form the user input if exists
        if connector.proxy.options[:user_metadata]
          connector.proxy.options[:user_metadata].each do |meta|
            item.meta.new(name: meta[:name], value: meta[:value], generator: :user)
          end
        end

        # # check for author and if not exists add current one
        if item.meta.where(name: 'author').empty?
          item.meta.new(name: 'author', value: user.name, generator: :user)
        end

        # find if this name already exists
        existing = Narra::Item.find_by(name: item.name, library: library._id.to_s)
        # check
        if existing
          # check if it was acquired by same connector
          if existing.meta.find_by(name: 'connector', generator: 'source').value == connector.proxy.connector.to_s
            # it has a same source it will be overwritten
            existing.destroy!
          end
        end

        # Generate text preview
        if item.type == :text
          item.preview = Core::Items.truncate(item.text, length: Narra::Tools::Settings.text_preview_length.to_i)
        end

        # save item
        item.save!

        # start transcode process
        unless item.type == :text
          process(type: :transcoder, item: item._id.to_s, identifier: connector.proxy.download_url)
        end

        # return item
        return item
      end
    end
  end
end
