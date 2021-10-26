# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'streamio-ffmpeg'

if Narra::Tools::Settings.ffmpeg_binary.is_a?(String) && File.executable?(Narra::Tools::Settings.ffmpeg_binary)
  FFMPEG.ffmpeg_binary = Narra::Tools::Settings.ffmpeg_binary
end

if Narra::Tools::Settings.ffprobe_binary.is_a?(String) && File.executable?(Narra::Tools::Settings.ffprobe_binary)
  FFMPEG.ffprobe_binary = Narra::Tools::Settings.ffprobe_binary
end
