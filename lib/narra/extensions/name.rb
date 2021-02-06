#
# Copyright (C) 2021 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>
#

module Narra
  module Extensions
    module Name
      extend ActiveSupport::Concern
      include Narra::Extensions::Meta

      included do
        after_create :narra_name_initialize
      end

      def name
        # get public meta
        meta = get_meta(name: 'name')
        # return
        meta.nil? ? '' : meta.value
      end

      def name=(name)
        self.update_meta(name: 'name', value: name)
      end

      protected

      def narra_name_initialize
        self.add_meta(name: 'name', value: '', hidden: false, public: true)
      end
    end
  end
end
