# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  class AudioProxyUploader < Narra::BaseUploader
    include Narra::Transcoders::Media

    # set up encoder process to generate proxies
    process transcode_audio: [Narra::Tools::Settings.audio_proxy_extension.to_sym, audio_bitrate: Narra::Tools::Settings.audio_proxy_bitrate, custom: '-vn', videoinfo: true]

    def store_dir
      Narra::Storage::NAME + "/items/#{model._id.to_s}"
    end
  end
end
