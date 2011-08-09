module Bandit
  class MemoryStorage < BaseStorage
    def initialize(config)
      @memory = Hash.new nil
    end

    # increment key by count
    def incr(key, count=1)
      @memory[key] = get(key) + count
    end

    # initialize key if not set
    def init(key, value)
      @memory[key] = value if @memory[key].nil?
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      @memory.fetch(key, default)
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      @memory[key] = value
    end

    def clear!
      @memory = Hash.new nil
    end
  end
end
