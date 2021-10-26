# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/core'
require 'rails'

module Narra
  module Core
    class Engine < Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/**/"]
    end
  end
end
