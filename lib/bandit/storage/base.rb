# store total count for this alternative
# conversions:<experiment>:<alternative> = count
# participants:<experiment>:<alternative> = count

# store first time an alternative is used
# altstart:<experiment>:<alternative> = timestamp

# store total count for this alternative per day and hour
# conversions:<experiment>:<alternative>:<date>:<hour> = count
# participants:<experiment>:<alternative>:<date>:<hour> = count

# every so often store current epsilon
# state:<experiment>:<player>:epsilon = 0.1

module Bandit
  class BaseStorage
    def self.get_storage(name, config)
      config ||= {}

      case name
      when :memory then MemoryStorage.new(config)
      when :memcache then MemCacheStorage.new(config)
      when :dalli then DalliStorage.new(config)
      when :redis then RedisStorage.new(config)
      else raise UnknownStorageEngineError, "#{name} not a known storage method"
      end
    end

    # increment key by count
    def incr(key, count)
      raise NotImplementedError
    end

    # initialize key if not set
    def init(key, value)
      raise NotImplementedError
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      raise NotImplementedError
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      raise NotImplementedError
    end

    # clear all stored values
    def clear!
      raise NotImplementedError
    end

    def incr_participants(experiment, alternative, count=1, date_hour=nil)
      date_hour ||= DateHour.now

      # initialize first start time for alternative if we haven't inited yet
      init alt_started_key(experiment, alternative), date_hour.to_i

      # increment total count and per hour count
      incr part_key(experiment, alternative), count
      incr part_key(experiment, alternative, date_hour), count
    end

    def incr_conversions(experiment, alternative, count=1, date_hour=nil)
      # increment total count and per hour count
      incr conv_key(experiment, alternative), count
      incr conv_key(experiment, alternative, date_hour || DateHour.now), count
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def participant_count(experiment, alternative, date_hour=nil)
      get part_key(experiment, alternative, date_hour)
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def conversion_count(experiment, alternative, date_hour=nil)
      get conv_key(experiment, alternative, date_hour)
    end

    def player_state_set(experiment, player, name, value)
      set player_state_key(experiment, player, name), value
    end

    def player_state_get(experiment, player, name)
      get player_state_key(experiment, player, name), nil
    end

    def alternative_start_time(experiment, alternative)
      secs = get alt_started_key(experiment, alternative), nil
      secs.nil? ? nil : Time.at(secs).to_date_hour
    end

    # if date_hour is nil, create key for total
    # otherwise, create key for hourly based
    def part_key(exp, alt, date_hour=nil)
      parts = [ "participants", exp.name, alt ]
      parts += [ date_hour.date, date_hour.hour ] unless date_hour.nil?
      make_key parts
    end

    # key for alternative start
    def alt_started_key(experiment, alternative)
      make_key [ "altstarted", experiment.name, alternative ]
    end

    # if date_hour is nil, create key for total
    # otherwise, create key for hourly based
    def conv_key(exp, alt, date_hour=nil)
      parts = [ "conversions", exp.name, alt ]
      parts += [ date_hour.date, date_hour.hour ] unless date_hour.nil?
      make_key parts
    end

    def player_state_key(exp, player, varname)
      make_key [ "state", exp.name, player.name, varname ]
    end

    def make_key(parts)
      parts.join(":")
    end

    def with_failure_grace(fail_default=0)
      begin
        yield
      rescue
        Bandit.storage_failed!
        Rails.logger.error "Storage method #{self.class} failed.  Falling back to memory storage."
        fail_default
      end
    end
  end
end
