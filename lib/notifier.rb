class Notifier
  def self.send_reminders
    return if Date.today.wday != 1

    people = YAML.load_file("#{Rails.root}/config/people.yml")
    people.shuffle!

    until people.empty?
      group_size = 4
      group_size = 3 if people.length == 5 || people.length == 6
      group = people.slice!(0, group_size)
      Reminder.reminder(group).deliver
    end
  end
end