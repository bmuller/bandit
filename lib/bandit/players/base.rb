module Bandit
  class BasePlayer
    def self.get_player(name, config)
      config ||= {}

      case name 
      when :round_robin then RoundRobinPlayer.new(config)
      else raise UnknownPlayerEngineError, "#{name} not a known player type"
      end

    end
    
    def choose_alternattive(experiment)
      # return the alternative that should be chosen
      raise NotImplementedError
    end
  end
end
