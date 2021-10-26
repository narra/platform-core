# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Schedulers
      class Thumbnails < Narra::SPI::Scheduler

        @identifier = :thumbnails
        @name = 'Thumbnails Updater'
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
end
