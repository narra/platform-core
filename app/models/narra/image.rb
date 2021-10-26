# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class Image < Item

    # define image proxy object / transcoding process
    mount_uploader :image, Narra::ImageProxyUploader

    def prepared?
      !image_proxy_hq.url.nil? && !image_proxy_lq.url.nil?
    end
  end
end
