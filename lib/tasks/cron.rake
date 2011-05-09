task :cron => :environment do
  DailyCron.work
end
