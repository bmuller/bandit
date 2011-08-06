module Bandit
  class Metric
    attr_accessor :name, :description
    @@instances = []

    def self.create(name, desc=nil)
      desc ||= "Count of #{name}"
      Metric.new(:name => name, :description => desc)
    end

    def initialize(args=nil)
      args.each { |k,v| send "#{k}=", v } unless args.nil?
      @@instances << self
    end

    def self.instances
      @@instances
    end
  end
end
