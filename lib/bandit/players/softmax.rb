module Bandit
  class SoftmaxPlayer < BasePlayer
    include Memoizable

    def choose_alternative(experiment)
      memoize(experiment.name) {
        t = getTemperature(experiment)
        norms = experiment.alternatives.map { |alt| 
          Math.exp(experiment.conversion_rate(alt) / (t * 100))
        }
        scale = norms.reduce(:+)
        probs = norms.map { |n| n / scale }
        a = alternative_index(probs)
        experiment.alternatives[alternative_index(probs)]
      }
    end

    private

    def alternative_index(probs)
      p = rand
      prob_sum = 0.0

      probs.size.times { |i|
        prob_sum += probs[i]
        return i if prob_sum > p
      }

      return probs.size - 1
    end

    def getTemperature(experiment)
      @config['temperature'].to_f || 0.2
    end
  end
end
