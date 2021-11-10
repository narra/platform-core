# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Copy

      def Core.copy(source_object, destination_object, user_id, options = {})
        # resolve object type
        if source_object.is_a?(Narra::Project)
          process(type: :copy, project: source_object._id.to_s, destination: destination_object._id.to_s, options: options, user: user_id)
        elsif source_object.is_a?(Narra::Library)
          process(type: :copy, library: source_object._id.to_s, destination: destination_object._id.to_s, options: options, user: user_id)
        end
      end
    end
  end
end
