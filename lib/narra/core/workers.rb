# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require_relative 'workers/action'
require_relative 'workers/generator'
require_relative 'workers/items'
require_relative 'workers/synthesizer'
require_relative 'workers/transcoder'
require_relative 'workers/purge'
require_relative 'workers/export'
require_relative 'workers/import'

module Narra
  module Core
    module Workers
    end
  end
end
