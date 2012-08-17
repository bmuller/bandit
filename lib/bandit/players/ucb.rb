module Bandit
  class UcbPlayer < BasePlayer
    include Memoizable

    def choose_alternative(experiment)
      best_alternative(experiment)
    end

    def best_alternative(experiment)
      best = nil
      best_rate = nil
      experiment.alternatives.each { |alt|
        rate = experiment.conversion_rate(alt) + confidence_interval(experiment, alt)
        if best_rate.nil? or rate > best_rate
          best = alt
          best_rate = rate
        end
      }
      best
    end

    def confidence_interval(experiment, alt, date_hour=nil)
      # force alt_participant_count to start at 1 to avoid divide by 0 errors
      # force total_participant_count to start at 1 to avoid taking log of 0 errors
      total_participant_count = [experiment.total_participant_count(date_hour), 1].max
      alt_participant_count = [experiment.participant_count(alt, date_hour), 1].max
      # scale to 100 to match conversion_rate output
      Math.sqrt(2 * Math.log(total_participant_count) / alt_participant_count) * 100
    end
  end
end
