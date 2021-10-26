# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Generator
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :generators

        def perform(options)
          # check
          return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # get item
            item = Narra::Item.find(options['item'])
            # fire event
            @event.run!
            # get generator
            generator = Narra::Core.generators.detect { |g| g.identifier == options['identifier'].to_sym }
            # perform generate if generator is available
            generator.new(item, @event).generate(options['options']) unless item.nil? || !item.prepared?
          rescue => e
            # reset event
            @event.reset!
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'generator')
            # throw
            raise e
          else
            # finish progress
            set_progress(1.0)
            # log
            Narra::Core::LOGGER.log_info("Item #{item.name}#'#{options['item']} successfully generated", 'generator')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
