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

require 'timecode'

module Narra
  module Extensions
    module Mark

      def process_mark(mark)
        # get input and out
        src_in = (mark[:input].to_f / @sequence.fps).to_f
        src_out = (mark[:output].to_f / @sequence.fps).to_f
        # return mark
        Narra::MarkFlow.new(clip: mark[:clip], row: mark[:row], input: src_in, output: src_out)
      end
    end
  end
end