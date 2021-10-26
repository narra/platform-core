# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Synthesizer
        include Sidekiq::Worker
        include Narra::Extensions::Progress

        sidekiq_options :queue => :synthesizers

        def perform(options)
          # check
          return if options['project'].nil? || options['identifier'].nil? || options['event'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])

            # get project
            project = Narra::Project.find(options['project'])

            # fire event
            @event.run!

            # get generator
            synthesizer = Narra::Core.synthesizers.detect { |s| s.identifier == options['identifier'].to_sym }

            # perform generate if generator is available
            synthesizer.new(project, @event).synthesize(options['options']) unless project.nil?
          rescue => e
            # reset event
            @event.reset!
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'synthesizer')
            # throw
            raise e
          else
            # finish progress
            set_progress(1.0)
            # log
            Narra::Core::LOGGER.log_info("Project #{project.name}#'#{options['project']} successfully synthesized", 'synthesizer')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
