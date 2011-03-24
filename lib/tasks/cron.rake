task :cron => :environment do
  Notifier.send_reminders
end