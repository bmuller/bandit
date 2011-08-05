module Bandit
  class MemoryStorage < BaseStorage
    def initialize(config)
      @participants = {}
      @conversions = {}
      @epsilon = config['epsilon']
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
    
    def epsilon
      @epsilon
    end

    def epsilon=(value)
      @epsilon = value
    end
  end
end
