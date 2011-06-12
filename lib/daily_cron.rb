class DailyCron
  SUNDAY = 0
  MONDAY = 1

  def self.work
    today = Date.today.wday

    Person.send_reminders if today == SUNDAY
    Person.send_invitations if today == MONDAY
  end
end