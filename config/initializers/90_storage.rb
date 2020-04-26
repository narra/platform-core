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

require 'carrierwave'

# Setup instance name
module Narra
  module Storage
    NAME = 'narra-' + (ENV['NARRA_INSTANCE_NAME'] ||= 'testing') + '-storage'
    SELECTED = Narra::Storages::Local
    INSTANCE = nil
  end
end

# Recreating temp
FileUtils.rm_rf(Narra::Tools::Settings.storage_temp)
FileUtils.mkdir_p(Narra::Tools::Settings.storage_temp)

# Search for a storage type
Narra::SPI::Storage.descendants.each do |storage|
  if storage.identifier != :local && storage.valid?
    Narra::Storage::SELECTED = storage
  end
end

# Storage initialization
Narra::Storage::INSTANCE = Narra::Storage::SELECTED.new
