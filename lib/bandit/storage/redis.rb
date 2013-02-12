module Bandit
  class RedisStorage < BaseStorage
    def initialize(config)
      require 'redis'

      if config[:url]
        uri = URI.parse(config[:url])
        config[:host] = uri.host
        config[:port] = uri.port
        config[:password] = uri.password
      else
        config[:host] ||= 'localhost'
        config[:port] ||= 6379
      end
      config[:db] ||= "bandit"

      @redis = Redis.new config
    end

    # increment key by count
    def incr(key, count=1)
      with_failure_grace(count) {
        @redis.incrby(key, count)
      }
    end

    # initialize key if not set
    def init(key, value)
      with_failure_grace(value) {
        @redis.set(key, value) if get(key, nil).nil?
      }
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      with_failure_grace(default) {
        val = @redis.get(key)
        return default if val.nil?
        val.numeric? ? val.to_i : val
      }
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      with_failure_grace(value) {
        @redis.set(key, value)
      }
    end

    def clear!
      with_failure_grace(nil) {
        @redis.flushdb
      }
    end
  end
end
