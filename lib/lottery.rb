module Lottery
  def self.send_invitations!
    Location.all.each do |location|
      shuffled_people = location.people.subscribed.opted_in.all.shuffle

      if shuffled_people.length > 2
        groups = Grouper.make_groups(shuffled_people)
        total_people = location.people
        groups.each do |group|
          Notifier.invite(group, location, total_people, groups).deliver
        end
      end
    end

    Person.update_all :opt_in => false
  end

  def self.send_reminders!
    Person.all.each do |person|
      Notifier.remind(person).deliver if person.subscribed?
    end
  end
end