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
  module Extensions
    module Progress

      def event=(event)
        @event = event
      end

      def event
        @event
      end

      def set_progress(progress, message = nil)
        # cache progress locally
        @progress ||= 0.0
        # if changed more than 2% push it
        if (progress - @progress) >= 0.02 || (progress - @progress) < 0
          # update event
          event.set_progress(progress)
          # update cache
          @progress = progress
        end
        # set up message if entered
        @event.update_attribute(:message, message) if message
      end
    end
  end
end