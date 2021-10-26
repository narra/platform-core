# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'carrierwave'

# Setup instance name
module Narra
  module Storage
    NAME = 'narra-' + (ENV['NARRA_INSTANCE_NAME'] ||= 'testing') + '-storage'
    SELECTED = Narra::Core::Storages::Local
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
# Log
Narra::Core::LOGGER.log_info("#{Narra::Storage::SELECTED} registered", 'storage')
