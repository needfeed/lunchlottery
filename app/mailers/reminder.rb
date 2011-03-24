class Reminder < ActionMailer::Base
  def reminder(addresses)
    @addresses = addresses
    mail(:to =>addresses,
         :subject => "Your lunch tomorrow",
         :sender => "dine@lunchlottery.com")
  end
end