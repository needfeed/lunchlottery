class Reminder < ActionMailer::Base
  def reminder(address)
    subject "Your lunch tomorrow"
    recipients address
  end
end