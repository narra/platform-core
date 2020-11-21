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
  module Tools
    module Logger

      # return default logger
      def self.default_logger
        @logger ||= Rails.logger
      end

      protected

      def logger
        Narra::Tools::Logger.default_logger
      end

      def log_info(message)
        logger.info(message)
      end

      def log_error(message)
        logger.error(message)
      end

      def log_debug(message)
        logger.debug(message)
      end
    end
  end
end
