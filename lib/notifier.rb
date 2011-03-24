class Notifier
  def self.send_reminders
    return if Date.today.wday != 1

    people = YAML.load_file("#{Rails.root}/config/people.yml")

    until people.empty?
      Reminder.reminder(people.slice!(0, 4)).deliver
    end
  end
end