module Bandit
  class Experiment
    attr_accessor :name, :title, :description, :alternatives
    @@instances = []

    def self.create(name)
      e = Experiment.new(:name => name)
      yield e
      e.validate!
      e
    end

    def initialize(args=nil)
      args.each { |k,v| send "#{k}=", v } unless args.nil?
      @@instances << self
      @storage = Bandit.storage
    end

    def self.instances
      @@instances
    end

    def choose(default=nil)
      if default && alternatives.include?(default)
        alt = default
      else
        alt = Bandit.player.choose_alternative(self)
        @storage.incr_participants(self, alt)
      end
      alt
    end

    def convert!(alt, count=1)
      @storage.incr_conversions(self, alt, count)
    end

    def validate!
      [:title, :alternatives].each { |field|        
        unless send(field)
          raise MissingConfigurationError, "#{field} must be set in experiment #{name}"
        end
      }
    end

    def conversion_count(alt, date_hour=nil)
      @storage.conversion_count(self, alt, date_hour)
    end

    def participant_count(alt, date_hour=nil)
      @storage.participant_count(self, alt, date_hour)
    end

    def conversion_rate(alt)
      pcount = participant_count(alt)
      ccount = conversion_count(alt)
      (pcount == 0 or ccount == 0) ? 0 : (ccount.to_f / pcount.to_f * 100.0)
    end

    def alternative_start(alt)
      @storage.alternative_start_time(self, alt)
    end
  end
end
