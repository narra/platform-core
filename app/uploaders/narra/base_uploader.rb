# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class BaseUploader < CarrierWave::Uploader::Base

    def url(options = {})
      # process url via storage modificator
      Narra::Storage::INSTANCE.url(super(options))
    end
  end
end
