module Bandit
  class RoundRobinPlayer
    def choose_alternattive(experiment)
      experiment.alternatives.choice
    end
  end
end
