# store total count for this alternative
# <experiment>:<alternative>:conversions = count
# <experiment>:<alternative>:participants = count

# store total count for this alternative per day and hour
# <experiment>:<alternative>:conversions:<date>:<hour> = count
# <experiment>:<alternative>:participants:<date>:<hour> = count

# every so often store current epsilon
# <experiment>:epsilon = 0.1

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
    
    def player_state_set(player, name, value)
      raise NotImplementedError      
    end

    def player_state_get(player, name)
      raise NotImplementedError
    end
  end
end
