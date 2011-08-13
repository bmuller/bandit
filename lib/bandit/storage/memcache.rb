module Bandit
  class MemCacheStorage < BaseStorage
    def initialize(config)
      require 'memcache'
      config[:namespace] ||= 'bandit'
      @memcache = MemCache.new(config.fetch(:host, 'localhost:11211'), config)
    end

    # increment key by count
    def incr(key, count=1)
      # memcache incr seems to be broken in memcache-client gem
      set(key, get(key, 0) + count)
    end

    # initialize key if not set
    def init(key, value)      
      @memcache.add(key, value)
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      @memcache.get(key) || default
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      @memcache.set(key, value)
    end

    def clear!
      @memcache.flush_all
    end
  end
end
