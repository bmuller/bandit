module Bandit
  class RedisStorage < BaseStorage
    def initialize(config)
      require 'redis'
      config[:host] ||= 'localhost'
      config[:port] ||= 6379
      config[:db] ||= "bandit"
      @redis = Redis.new config
    end

    # increment key by count
    def incr(key, count=1)
      @redis.incrby(key, count)
    end

    # initialize key if not set
    def init(key, value)
      @redis.set(key, value) if get(key, nil).nil?
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      val = @redis.get(key)
      return default if val.nil?
      val.numeric? ? val.to_i : val
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      @redis.set(key, value)
    end

    def clear!
      @redis.flushdb
    end
  end
end
