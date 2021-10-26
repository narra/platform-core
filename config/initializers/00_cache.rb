# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

Narra::Tools::Settings.cache = ActiveSupport::Cache::RedisCacheStore.new(namespace: 'narra_settings', url: 'redis://redis:6379/0', reconnect_attempts: 1)
