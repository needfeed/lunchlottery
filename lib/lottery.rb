module Lottery
  def self.send_invitations!
    Location.all.each do |location|
      shuffled_people = location.people.opted_in.all.shuffle
      
      if shuffled_people.length > 2
        groups = Grouper.make_groups(shuffled_people)
        groups.each do |group|
          Notifier.invite(group, location).deliver
        end
      end
    end

    Person.update_all :opt_in => false
  end

  def self.send_reminders!
    Person.all.each do |person|
      Notifier.remind(person).deliver
    end
  end
end