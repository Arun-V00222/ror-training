schedule_file = "config/schedule.yml"

redis_host = Rails.application.secrets.redis && Rails.application.secrets.redis['host'] || '127.0.0.1'
redis_port = Rails.application.secrets.redis && Rails.application.secrets.redis['port'] || 6379

Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}", :namespace => 'sidekiq', :size => 12}
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}", :namespace => 'sidekiq', :size => 12 }
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
