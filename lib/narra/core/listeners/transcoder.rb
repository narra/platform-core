# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Listeners
      class Transcoder < Narra::SPI::Listener
        include Narra::Extensions::Progress

        # default values
        @identifier = :transcoder
        @name = 'Transcoder Actions'
        @description = 'Transcoder Actions'
        # register events
        @events = [:narra_transcoder_done, :narra_transcoder_progress_changed]

        # callbacks
        def narra_transcoder_done(options)
          # get item
          item = Narra::Item.find(options[:item])
          # run generators
          item.generate
          # log
          Narra::Core::LOGGER.log_info("Item #{item.name}##{item._id.to_s} transcoded successfully", 'transcoder')
        end

        def narra_transcoder_progress_changed(options)
          # log
          set_progress(options[:progress], "Transcoding #{options[:type]} version")
        end
      end
    end
  end
end
