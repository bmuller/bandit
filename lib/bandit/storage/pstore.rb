module Bandit
  class PstoreStorage < BaseStorage
    def initialize(config)
      if config[:use_yaml_store]
        require 'yaml/store'
        @store = YAML::Store.new(config[:file] || 'bandit.yamlstore')
      else
        require 'pstore'
        @store = PStore.new(config[:file] || 'bandit.pstore')
      end
    end

    # increment key by count
    def incr(key, count=1)
      @store.transaction do
        unless @store[key].nil?
          @store[key] = @store[key] + count
        else
          @store[key] = count
        end
      end
    end

    # initialize key if not set
    def init(key, value)
      @store.transaction do
        @store[key] = value if @store[key].nil?
      end
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      @store.transaction(true) do
        @store[key] || default
      end
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      @store.transaction do
        @store[key] = value
      end
    end

    def clear!
      @store.transaction do
        @store.roots.each do |key|
          @store.delete(key)
        end
      end
    end
  end
end
