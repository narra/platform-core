# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Transcoders
      module MediaThumbnails

        def thumbnails(movie)
          # calculate seek ratio
          ratio = (movie.duration / Integer(Narra::Tools::Settings.thumbnail_count)).to_i

          # generate all thumbnails
          (1..Narra::Tools::Settings.thumbnail_count.to_i).each do |count|
            begin
              # seek
              seek = '%05d' % (((count * ratio) == movie.duration) ? (count * ratio) - 1 : count * ratio)
              # get thumbnail object
              thumbnail = File.join(File.dirname(current_path), "thumbnail_#{seek}.#{Narra::Tools::Settings.thumbnail_extension}")
              # generate
              movie.screenshot(thumbnail, { seek_time: seek.to_i }, validate: false)
              # save thumbnail
              model._thumbnails << Narra::Thumbnail.new(file: File.open(thumbnail))
            ensure
              # delete temp file
              FileUtils.rm_f(thumbnail)
            end
          end
        end
      end
    end
  end
end
