module Bandit
  class Experiment
    attr_accessor :name, :title, :description, :metric, :alternatives
    @@instances = []

    def self.create(name)
      e = Experiment.new(:name => name)
      yield e
      e.validate!
    end

    def initialize(args=nil)
      args.each { |k,v| send "#{k}=", v } unless args.nil?
      @@instances << self
      @storage = Bandit.storage
    end

    def self.instances
      @@instances
    end

    def choose(default = nil)
      if not default.nil? and alternatives.include? default
        alt = default
      else
        alt = Bandit.player.choose_alternative(self)
      end
      @storage.incr_participants(self, alt)
      alt
    end

    def convert!(alt, count=1)
      @storage.incr_conversions(self, alt, count)
    end

    def validate!
      [:metric, :alternatives].each { |field|        
        unless send(field)
          raise MissingConfigurationError, "#{field} must be set in experiment #{name}"
        end
      }
    end
  end
end
