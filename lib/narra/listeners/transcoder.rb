#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

module Narra
  module Listeners
    class Transcoder
      include Narra::Tools::Logger
      include Narra::Extensions::Progress

      def narra_transcoder_done(options)
        # get item
        item = Narra::Item.find(options[:item])
        # run generators
        item.generate
        # log
        log_info('listener#transcoder') { 'Item ' + item.name + '#' + item._id.to_s + ' transcoded successfully.'}
      end

      def narra_transcoder_progress_changed(options)
        # log
        set_progress(options[:progress], "Transcoding #{options[:type]} version")
      end
    end
  end
end