class Notifier
  MONDAY = 1

  def self.send_reminders
    return unless Date.today.wday == MONDAY || Date.today == Date.parse("2011-03-23")

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