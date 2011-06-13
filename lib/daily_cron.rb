class DailyCron
  SUNDAY = 0
  MONDAY = 1

  def self.work
    today = Date.today.wday

    Lottery.send_reminders! if today == SUNDAY
    Lottery.send_invitations! if today == MONDAY
  end
end