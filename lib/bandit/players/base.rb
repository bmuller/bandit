module Bandit
  class BasePlayer
    def self.get_player(name, config)
      config ||= {}

      case name 
      when :round_robin then RoundRobinPlayer.new(config)
      else raise UnknownPlayerEngineError, "#{name} not a known player type"
      end

    end

    def initialize(config)
      @config = config
    end
    
    def choose_alternative(experiment)
      # return the alternative that should be chosen
      raise NotImplementedError
    end
  end
end
