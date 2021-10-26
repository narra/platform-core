# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class ThumbnailUploader < Narra::BaseUploader
    include CarrierWave::MiniMagick

    process resize_to_fill: [Narra::Tools::Settings.thumbnail_resolution.split('x')[0].to_i, Narra::Tools::Settings.thumbnail_resolution.split('x')[1].to_i]
    process convert: Narra::Tools::Settings.thumbnail_extension

    def filename
      super.chomp(File.extname(super)) + ".#{Narra::Tools::Settings.thumbnail_extension}" if original_filename.present?
    end

    def store_dir
      Narra::Storage::NAME + "/items/#{model.item_id}"
    end
  end
end
