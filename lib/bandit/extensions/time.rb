class Time
  def to_date_hour
    Bandit::DateHour.new Date.new(year, month, day), hour
  end
end
