task :cron => :environment do
  SUNDAY = 0
  MONDAY = 1

  case Date.today.wday
    when SUNDAY
#      Notifier.send_reminders
    when MONDAY
     Person.send_invitation
  end

end