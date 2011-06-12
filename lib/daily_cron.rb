class DailyCron
  SUNDAY = 0
  MONDAY = 1

  def self.work
    return
    
    case Date.today.wday
      when SUNDAY
        Person.send_reminders
      when MONDAY
        Person.send_invitations
    end
  end
end