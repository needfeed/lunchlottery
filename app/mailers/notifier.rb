class Notifier < ActionMailer::Base
  def invite(people)
    @people = people
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
end