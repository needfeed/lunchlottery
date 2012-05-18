class Dates
  def self.isday?(date, weekday)
    date.strftime("%A").casecmp(weekday) == 0
  end

  def self.next_occurrence (weekday)
    now = DateTime.now.to_date
    now = now.next until isday?(now, weekday)
    now.to_datetime + 1.day - 1.second
  end

  def self.day_before(day_name)
    (Date.parse(day_name) - 1.day).strftime("%A")
  end
end