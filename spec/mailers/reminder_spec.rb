require 'spec_helper'

describe Reminder do
  it "should send an email" do
    Reminder.reminder(["one@example.com", "two@example.com"]).deliver

    ActionMailer::Base.deliveries.length.should == 1

    message = ActionMailer::Base.deliveries.first
    message.subject.should =~ /Your lunch tomorrow/
    message.to.should == ["one@example.com", "two@example.com"]
    message.body.to_s.should =~ /Hello/
    message.body.to_s.should =~ /one@example\.com/
    message.body.to_s.should =~ /two@example\.com/
  end
end