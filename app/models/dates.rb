class Dates
  def self.tuesday?(date)
    date.wday == 2
  end

  def self.next_tuesday
    now = DateTime.now.to_date
    now = now.next until tuesday?(now)
    now.to_datetime + 1.day - 1.second
  end
end