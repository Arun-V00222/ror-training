module Redis
   class << self
     def redis
       @redis ||= Redis.new(url: (ENV['REDISTOGO_URL'] || 'redis://127.0.0.1:6379'))
     end

     def sidekiq?
      begin
        redis_info = Sidekiq.redis { |conn| conn.info }
        true
      rescue
         false
       end

      end
   end
 end
