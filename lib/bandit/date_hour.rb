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

    def upto(other)
      n = DateHour.new(@date, @hour)
      while n <= other
        yield n
        n += 1
      end
    end

    def +(hours)
      (to_time + (hours * 3600)).to_date_hour
    end

    def ==(other)
      @date == other.date and @hour == other.hour
    end

    def <(other)
      @date < other.date and @hour < other.hour
    end

    def >(other)
      @date > other.date and @hour > other.hour
    end

    def >=(other)
      @date >= other.date and @hour >= other.hour
    end

    def <=(other)
      @date <= other.date and @hour <= other.hour
    end

    def to_time
      Time.mktime(@date.year, @date.month, @date.day, @hour, 0)
    end

    def to_s
      "#{@date.to_s} #{@hour}:00:00"
    end
  end

end
