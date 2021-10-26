# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave/mongoid'

module Narra
  class Text < Item

    # Fields
    # TODO listener when text value is changed to regenarate preview
    field :preview, type: String

    # Get text value directly
    def text
      self.get_meta(name: 'text').value
    end

    # overriding to check whether the text is prepared
    def prepared?
      true
    end
  end
end
