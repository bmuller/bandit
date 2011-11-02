module Bandit
  class RoundRobinPlayer < BasePlayer
    def choose_alternative(experiment)
      experiment.alternatives.sample
    end
  end
end
