# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'
require 'sidekiq-scheduler'

# load redis config
redis_config = YAML.load(ERB.new(File.new(Rails.root + 'config/redis.yml').read).result)

Sidekiq.configure_server do |config|
  # Configure Redis connection
  config.redis = {:url => "redis://#{redis_config['hostname']}:#{redis_config['port']}/0", :namespace => 'narra_sidekiq'}
  # Load all schedulers
  config.on(:startup) do
    Narra::SPI::Scheduler.descendants.each do |scheduler|
      # register scheduler
      Sidekiq.set_schedule(scheduler.name, {:class => scheduler, :every => scheduler.interval, :description => scheduler.description, :queue => 'schedulers'})
      # log
      Narra::Core::LOGGER.log_info("#{scheduler} registered", 'scheduler')
    end
  end
end

Sidekiq.configure_client do |config|
  # Configure Redis connection
  config.redis = {:url => "redis://#{redis_config['hostname']}:#{redis_config['port']}/0", :namespace => 'narra_sidekiq'}
end
