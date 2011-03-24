class Notifier
  def self.send_reminders
    people = YAML.load_file("#{Rails.root}/config/people.yml")

    until people.empty?
      Reminder.reminder(people.slice!(0, 4)).deliver
    end
  end
end