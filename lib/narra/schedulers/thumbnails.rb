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
  module Schedulers
    class Thumbnails < Narra::SPI::Scheduler

      @identifier = :thumbnails
      @title = 'Thumbnails Updater'
      @description = 'It updates thumbnails for project and libraries once per 10 minutes'
      @interval = '10m'

      def perform
        # Update items
        Narra::Item.all.each do |item|
          # Resolve thumbnails
          item.thumbnails = item._thumbnails.order_by(:random => 'asc').limit(Narra::Tools::Settings.thumbnail_count.to_i).collect { |thumbnail| thumbnail.file.url }
          # save
          item.save!
        end
        # Update libraries
        Narra::Library.all.each do |library|
          # Resolve thumbnails
          library.thumbnails = library.items.collect { |item| item.thumbnails }.sample(Narra::Tools::Settings.thumbnail_count.to_i)
        end
        # Update projects
        Narra::Project.all.each do |project|
          # Resolve thumbnails
          project.thumbnails = project.libraries.collect { |library| library.thumbnails }.sample(Narra::Tools::Settings.thumbnail_count.to_i)
        end
      end
    end
  end
end
