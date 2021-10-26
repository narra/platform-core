# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class IngestUploader < Narra::BaseUploader

    def filename
      model.name
    end

    def store_dir
      Narra::Storage::NAME + "/ingest/#{model._id.to_s}/"
    end
  end
end
