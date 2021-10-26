# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'wisper'
# workaround to register global listeners from upstream project
require 'narra/listeners'

# Register all global listeners
Narra::SPI::Listener.descendants.each do |listener|
  # iterate over events
  listener.events.each do |event|
    # each events has separate instance on the listener
    Wisper.subscribe(listener.new, event)
  end
end

# Register all default listeners
Narra::SPI::Default.descendants.each do |default|
  default.listeners.each do |listener|
    Wisper.subscribe(listener[:instance], on: listener[:event])
  end
end

# Register all synthesizer listeners
Narra::SPI::Synthesizer.descendants.each do |synthesizer|
  synthesizer.listeners.each do |listener|
    Wisper.subscribe(listener[:instance], on: listener[:event])
  end
end
