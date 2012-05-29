module Bandit
  class DalliStorage < BaseStorage
    def initialize(config)
      require 'dalli'
      config[:namespace] ||= 'bandit'
      @dalli = Dalli::Client.new(config.fetch(:host, 'localhost:11211'), config)
    end

    # increment key by count
    def incr(key, count=1)
      # dalli incr is broken just like in memcache-client gem
      with_failure_grace(count) {
        set(key, get(key, 0) + count)
      }
    end

    # initialize key if not set
    def init(key, value)
      with_failure_grace(value) {
        @dalli.add(key, value)
      }
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      with_failure_grace(default) {
        @dalli.get(key) || default
      }
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      with_failure_grace(value) {
        @dalli.set(key, value)
      }
    end

    def clear!
      with_failure_grace(nil) {
        @dalli.flush_all
      }
    end
  end
end
