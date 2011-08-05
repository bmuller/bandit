module Bandit
  class Experiment
    attr_accessor :name, :title, :description, :metric, :alternatives, :default_alternative, :storage
    @@instances = []

    def initialize(args=nil)
      args.each { |k,v| send "#{k}=", v } unless args.nil?
      @@instances << self
    end

    def self.instances
      @@instances
    end
  end
end
