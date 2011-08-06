module Bandit
  class RoundRobinPlayer < BasePlayer
    def choose_alternative(experiment)
      experiment.alternatives.choice
    end
  end
end
