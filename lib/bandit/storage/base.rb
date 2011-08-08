# store total count for this alternative
# <experiment>:<alternative>:conversions = count
# <experiment>:<alternative>:participants = count

# store first time an alternative is used
# <experiment>:<alternative>:started = timestamp

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

    def incr_participants(experiment, alternative, count=1, date_hour=nil)
      raise NotImplementedError
    end
    
    def incr_conversions(experiment, alternative, count=1, date_hour=nil)
      raise NotImplementedError
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def participant_count(experiment, alternative, date_hour=nil)
      raise NotImplementedError
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def conversion_count(experiment, alternative, date=nil)
      raise NotImplementedError
    end
    
    def player_state_set(player, name, value)
      raise NotImplementedError      
    end

    def player_state_get(player, name)
      raise NotImplementedError
    end
    
    # if date_hour is nil, create key for total
    # otherwise, create key for hourly based
    def part_key(exp, alt, date_hour=nil)
      parts = [ exp.name, alt ]
      parts += ["participants", date_hour.date, date_hour.hour] unless date_hour.nil?
      make_key parts
    end

    # key for alternative start
    def alt_started_key(experiment, alternative)
      make_key [experiment.name, alternative, "started"]
    end

    # if date_hour is nil, create key for total
    # otherwise, create key for hourly based
    def conv_key(exp, alt, date_hour=nil)
      parts = [ exp.name, alt ]
      parts += ["conversions", date_hour.date, date_hour.hour] unless date_hour.nil?
      make_key parts
    end

    def make_key(parts)
      parts.join(":")
    end
  end
end
