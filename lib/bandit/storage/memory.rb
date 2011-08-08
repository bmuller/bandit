module Bandit
  class MemoryStorage < BaseStorage
    def initialize(config)
      @participants = Hash.new 0
      @conversions = Hash.new 0
      @player_state = Hash.new nil
      @alternative_starts = Hash.new nil
    end

    def incr_participants(experiment, alternative, count=1, date_hour=nil)
      key = part_key(experiment, alternative)
      akey = alt_started_key(experiment, alternative)
      @alternative_starts[akey] = Time.now.to_i unless @participants.has_key? key
      @participants[key] += count

      key = part_key(experiment, alternative, date_hour || DateHour.now)
      @participants[key] += count
    end
    
    def incr_conversions(experiment, alternative, count=1, date_hour=nil)
      key = conv_key(experiment, alternative)
      @conversions[key] += count

      key = conv_key(experiment, alternative, date_hour || DateHour.now)
      @conversions[key] += count
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def participant_count(experiment, alternative, date_hour=nil)
      key = date_hour.nil? ? part_key(experiment, alternative) : part_key(experiment, alternative, date_hour)
      @participants[key]
    end

    # if date_hour isn't specified, get total count
    # if date_hour is specified, return count for DateHour
    def conversion_count(experiment, alternative, date_hour=nil)
      key = date_hour.nil? ? conv_key(experiment, alternative) : conv_key(experiment, alternative, date_hour)
      @conversions[key]
    end
    
    def player_state_set(player, name, value)
      key = make_key [player.name, name]
      @player_state[key] = value
    end

    def player_state_get(player, name)
      key = make_key [player.name, name]
      @player_state[key]
    end

    def alternative_start_time(experiment, alternative)
      secs = @alternative_starts[alt_started_key(experiment, alternative)]
      secs.nil? ? nil : Time.at(secs).to_date_hour
    end
  end
end
