module Bandit
  class MemoryStorage < BaseStorage
    def initialize(config)
      @participants = {}
      @conversions = {}
      @player_state = {}
    end

    def incr_participants(experiment, alternative, count=1)
      key = [experiment.name, alternative].join(":")
      @participants[key] = @participants.fetch(key, 0) + count
    end
    
    def incr_conversions(experiment, alternative, count=1)
      key = [experiment.name, alternative].join(":")
      @conversions[key] = @conversions.fetch(key, 0) + count
    end

    def participant_count(experiment, alternative)
      key = [experiment.name, alternative].join(":")
      @participants.fetch(key, 0)
    end

    def conversion_count(experiment, alternative)
      key = [experiment.name, alternative].join(":")
      @conversions.fetch(key, 0)
    end
    
    def player_state_set(player, name, value)
      key = [player.name, name].join(":")
      @player_state[key] = value
    end

    def player_state_get(player, name)
      key = [player.name, name].join(":")
      @player_state.fetch(key, nil)
    end
  end
end
