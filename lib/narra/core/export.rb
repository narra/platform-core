# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module Core
    module Export

      def Core.export(project, return_object, user_id, options = {})
        process(type: :export, project: project, return: return_object, options: options, user: user_id)
      end
    end
  end
end
