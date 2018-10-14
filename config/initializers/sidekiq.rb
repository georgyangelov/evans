Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('EVANS_REDIS_URL', 'redis://localhost:6379'),
    namespace: Rails.application.config.course_id
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('EVANS_REDIS_URL', 'redis://localhost:6379'),
    namespace: Rails.application.config.course_id
  }
  config.logger = nil
end
