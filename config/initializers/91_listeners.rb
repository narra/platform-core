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

require 'wisper'

# Transcode listener fires generation process on the item
Wisper.subscribe(Narra::Listeners::Transcoder.new, on: :narra_transcoder_done)
# Library listener fires generation process on all items from the library
Wisper.subscribe(Narra::Listeners::Library.new, on: :narra_scenario_library_updated)
# Project listener fires synthetization process
Wisper.subscribe(Narra::Listeners::Project.new, on: :narra_scenario_project_updated)

# Register all default listeners
Narra::SPI::Default.descendants.each do |default|
  default.listeners.each do |listener|
    Wisper.subscribe(listener[:instance], on: listener[:event])
  end
end

# Register all synthesizer listeners
# Not calling Narra::Core directly due to workaround for spec testing
Narra::SPI::Synthesizer.descendants.each do |synthesizer|
  synthesizer.listeners.each do |listener|
    Wisper.subscribe(listener[:instance], on: listener[:event])
  end
end
