module Bandit
  class BaseStorage
    def self.get_storage(name, config)
      config ||= {}

      case name 
      when :memory then MemoryStorage.new(config)
      else raise UnknownStorageEngineError, "#{name} not a known storage method"
      end
    end

    def incr_participants(experiment, alternative, count=1)
      raise NotImplementedError
    end
    
    def incr_conversions(experiment, alternative, count=1)
      raise NotImplementedError
    end

    def participant_count(experiment, alternative)
      raise NotImplementedError
    end

    def conversion_count(experiment, alternative)
      raise NotImplementedError
    end
    
    def epsilon
      raise NotImplementedError      
    end

    def epsilon=(value)
      raise NotImplementedError
    end
  end
end
