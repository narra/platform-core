# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Transcoders
      module MediaInfo
        include Narra::Extensions::Meta

        def info_video(movie)
          # process movie and save meta
          add_meta(generator: :source, name: 'size', value: movie.size)
          add_meta(generator: :source, name: 'duration', value: movie.duration)
          add_meta(generator: :source, name: 'timecode', value: movie.metadata[:timecode]) unless movie.metadata.key?(:timecode)
          add_meta(generator: :source, name: 'bitrate', value: movie.bitrate)
          add_meta(generator: :source, name: 'video_codec', value: movie.video_codec)
          add_meta(generator: :source, name: 'colorspace', value: movie.colorspace)
          add_meta(generator: :source, name: 'resolution', value: movie.resolution)
          add_meta(generator: :source, name: 'width', value: movie.width)
          add_meta(generator: :source, name: 'height', value: movie.height)
          add_meta(generator: :source, name: 'frame_rate', value: movie.frame_rate)
          # if there is audio stream add meta too
          unless movie.audio_stream.nil?
            add_meta(generator: :source, name: 'audio_codec', value: movie.audio_codec)
            add_meta(generator: :source, name: 'audio_sample_rate', value: movie.audio_sample_rate)
            add_meta(generator: :source, name: 'audio_channels', value: movie.audio_channels)
          end
        end

        def info_audio(movie)
          # process audio and save meta
          add_meta(generator: :source, name: 'size', value: movie.size)
          add_meta(generator: :source, name: 'duration', value: movie.duration)
          add_meta(generator: :source, name: 'timecode', value: movie.metadata[:timecode]) unless movie.metadata.key?(:timecode)
          add_meta(generator: :source, name: 'bitrate', value: movie.bitrate)
          add_meta(generator: :source, name: 'audio_codec', value: movie.audio_codec)
          add_meta(generator: :source, name: 'audio_sample_rate', value: movie.audio_sample_rate)
          add_meta(generator: :source, name: 'audio_channels', value: movie.audio_channels)
        end

        def autosave
          false
        end
      end
    end
  end
end
