# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

# Register all settings
Narra::SPI::Default.descendants.each do |default|
  # Register setting to defaults
  default.settings.each do |key, value|
    Narra::Tools::Settings.defaults[key] = value
  end
  # log
  Narra::Core::LOGGER.log_info("#{default} registered", 'default')
end
