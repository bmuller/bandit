module Bandit
  class Metric
    attr_accessor :name, :description
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
