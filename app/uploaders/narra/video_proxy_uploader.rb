# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave/video'

module Narra
  class VideoProxyUploader < Narra::BaseUploader
    include Narra::Transcoders::Media

    # set up encoder process to generate proxies
    # process incoming video to hq proxy
    process transcode_video: [Narra::Tools::Settings.video_proxy_extension.to_sym, resolution: Narra::Tools::Settings.video_proxy_hq_resolution,
                              video_bitrate: Narra::Tools::Settings.video_proxy_hq_bitrate, videoinfo: true, thumbnails: true, type: :hq]

    version :lq do
      # generate lq proxy
      process transcode_video: [Narra::Tools::Settings.video_proxy_extension.to_sym, resolution: Narra::Tools::Settings.video_proxy_lq_resolution,
                                video_bitrate: Narra::Tools::Settings.video_proxy_lq_bitrate, type: :lq]
    end

    version :audio do
      # generate audio proxy
      process transcode_audio: [Narra::Tools::Settings.audio_proxy_extension.to_sym, audio_bitrate: Narra::Tools::Settings.audio_proxy_bitrate, custom: ['-vn'],  type: :audio]
      # change filename extension
      def full_filename(for_file)
        "#{File.basename(for_file, File.extname(for_file))}_#{version_name}.#{Narra::Tools::Settings.audio_proxy_extension}"
      end
    end

    # overriding filename to achieve rename of the extension while we are not keeping original file
    def filename
      super.chomp(File.extname(super)) + ".#{Narra::Tools::Settings.video_proxy_extension}" unless super.nil?
    end

    # default path in the storage
    def store_dir
      Narra::Storage::NAME + "/items/#{model._id.to_s}"
    end
  end
end

