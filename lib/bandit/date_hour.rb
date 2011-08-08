require 'date'

module Bandit

  class DateHour
    attr_accessor :date, :hour

    def initialize(date, hour)
      @date = date
      @hour = hour
    end

    def self.now
      DateHour.new Date.today, Time.now.hour
    end
  end

end
