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
      with_failure_grace(count) {
        set(key, get(key, 0) + count)
      }
    end

    # initialize key if not set
    def init(key, value)    
      with_failure_grace(value) {
        @memcache.add(key, value)
      }
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      with_failure_grace(default) {
        @memcache.get(key) || default
      }
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      with_failure_grace(value) {
        @memcache.set(key, value)
      }
    end

    def clear!
      with_failure_grace(nil) {
        @memcache.flush_all
      }
    end
  end
end
