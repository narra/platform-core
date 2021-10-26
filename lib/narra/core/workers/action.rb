# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

module Narra
  module Core
    module Workers
      class Action
        include Sidekiq::Worker

        sidekiq_options :queue => :actions

        def perform(options)
          # check
          return if options['items'].nil? || options['items'].empty? || options['identifier'].nil? || options['event'].nil? || options['returns'].nil?
          # perform
          begin
            # get event
            @event = Narra::Event.find(options['event'])
            # fire event
            @event.run!
            # get action class
            action = Narra::Core.actions.detect { |a| a.identifier == options['identifier'].to_sym }
            # get items
            items = options['items'].collect { |item| Narra::Item.find(item) }
            # create new action object
            action_object = action.new(items)
            action_object.returns = action_object.returns.collect do |ret|
              # append id field
              ret[:id] = options['returns'].detect { |r| r['name'] == ret[:name] }['id']
              # return modified object
              ret
            end
            # perform action over items
            result = action_object.perform(options['options'])
            # process returns
            if action_object.return != :void and action_object.returns.size and result.is_a?(Hash)
              # process returns
              action_object.returns.each do |ret|
                # get file and result
                return_object = Narra::Return.find(ret[:id])
                res = result[ret[:id]]
                # save file if available
                if return_object and res
                  return_object.file = Narra::Tools::FileIO.new(res, "#{ret[:name].parameterize(separator: '_')}_#{action.identifier}.#{action_object.return.to_s}")
                  return_object.save!
                end
              end
            end
          rescue => e
            # log
            Narra::Core::LOGGER.log_error(e.to_s, 'action')
            # reset event
            @event.reset!
            # throw
            raise e
          else
            # log
            Narra::Core::LOGGER.log_info("Action #{options['identifier']} successfully executed", 'action')
            # event done
            @event.done!
          end
        end
      end
    end
  end
end
