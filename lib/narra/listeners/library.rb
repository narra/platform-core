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
    class Library
      include Narra::Tools::Logger

      def narra_scenario_library_updated(options)
        # get library
        options[:libraries].each do |library_id|
          library = Narra::Library.find(library_id)
          # run new generators over all items from the library
          Narra::Item.generate(library.items)
          # log
          log_info('Library ' + library.name + '#' + library._id.to_s + 'scenario updated.')
        end
      end
    end
  end
end
