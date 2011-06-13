module Lottery
  def self.send_invitations!
    shuffled_people = Person.opted_in.all.shuffle
    groups = Grouper.make_groups(shuffled_people)
    groups.each do |group|
      Notifier.invite(group).deliver
    end

    Person.update_all :opt_in => true
  end

  def self.send_reminders!
    Person.all.each do |person|
      Notifier.remind(person).deliver
    end
  end
end