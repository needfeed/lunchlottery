class Notifier
  MONDAY = 1

  def self.send_reminders
    return unless Date.today.wday == MONDAY || Date.today == Date.parse("2011-03-23")

    people = Person.all_emails
    people.shuffle!

    until people.empty?
      group_size = 4
      group_size = 3 if [5, 6, 9].include?(people.length)
      group = people.slice!(0, group_size)
      Reminder.reminder(group).deliver
    end
  end
end