#
# Copyright (C) 2020 narra.eu
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
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

module Narra
  module Extensions
    module Public
      extend ActiveSupport::Concern
      include Narra::Extensions::Meta

      included do
        after_create :narra_public_initialize
      end

      def is_public?
        # get public meta
        meta = get_meta(name: 'public')
        # resolve
        meta.nil? ? false : meta.value == 'true'
      end

      def public=(public)
        self.update_meta(name: 'public', value: public)
      end

      protected

      def narra_public_initialize
        self.add_meta(name: 'public', value: false, hidden: true, public: false)
      end
    end
  end
end