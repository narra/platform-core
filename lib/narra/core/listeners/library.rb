# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Listeners
      class Library < Narra::SPI::Listener

        # default values
        @identifier = :library
        @name = 'Library Actions'
        @description = 'Library Actions'
        # register events
        @events = [:narra_scenario_library_updated]

        # callbacks
        def narra_scenario_library_updated(options)
          # get library
          options[:libraries].each do |library_id|
            library = Narra::Library.find(library_id)
            # run new generators over all items from the library
            Narra::Item.generate(library.items)
            # log
            Narra::Core::LOGGER.log_info('Library ' + library.name + '#' + library._id.to_s + 'scenario updated.')
          end
        end
      end
    end
  end
end
