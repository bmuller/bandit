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

    # given a block that is called w/ each DateHour for a day, inject over all DateHours
    def self.date_inject(date, initial=0)
      DateHour.new(date, 0).upto(DateHour.new(date, 23)) { |dh|
        initial = yield initial, dh
      }
      initial
    end

    def +(hours)
      (to_time + (hours * 3600)).to_date_hour
    end

    def ==(other)
      @date == other.date and @hour == other.hour
    end

    def <(other)
      @date < other.date or (@date == other.date and @hour < other.hour)
    end

    def >(other)
      @date > other.date or (@date == other.date and @hour > other.hour)
    end

    def >=(other)
      self > other or self == other
    end

    def <=(other)
      self < other or self == other
    end

    def to_time
      Time.mktime year, month, day, hour, 0
    end

    def to_s
      "#{@date.to_s} #{@hour}:00:00"
    end

    def to_i
      to_time.to_i
    end

    def year
      @date.year
    end

    def month
      @date.month
    end

    def day
      @date.day
    end
  end

end
