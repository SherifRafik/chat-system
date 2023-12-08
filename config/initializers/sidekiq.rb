# frozen_string_literal: true

sidekiq_config = { url: "redis://#{ENV.fetch('REDIS_HOST', 'redis')}:#{ENV.fetch('REDIS_PORT', 6379)}/0" }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
