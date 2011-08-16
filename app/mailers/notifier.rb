class Notifier < ActionMailer::Base
  def invite(people, location, total_people, groups)
    @people = people
    @location = location
    @opted_in_count = groups.inject(0) { |sum, group| sum + group.size }
    @total_people = total_people
    @group_stats = group_stats(groups)
    mail(:to => @people.map(&:email),
         :subject => "Your lunch tomorrow",
         :from => "dine@lunchlottery.com")
  end

  def remind(person)
    @person = person
    mail(:to => @person.email,
      :subject => "Lunch on Tuesday?",
      :from => "dine@lunchlottery.com")
  end

  def group_stats groups
    groups.reduce({}) do |stats, group|
      stats[group.size] ||= 0
      stats[group.size] += 1
      stats
    end
  end
end