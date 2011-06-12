require 'spec_helper'

describe Notifier do
  describe ".invite" do
    before do
      @people = new_people
      Notifier.invite(@people).deliver
    end

    it "sends the invite email" do
      ActionMailer::Base.deliveries.length.should == 1

      message = ActionMailer::Base.deliveries.first
      message.subject.should =~ /Your lunch tomorrow/
      message.to.should == @people.collect(&:email)
      message.from.should == ["dine@lunchlottery.com"]
      message.body.to_s.should match /Hello/
    end
  end

  describe ".remind" do
    before do
      @person = Person.create!(:email => "foo@example.com")
      Notifier.remind(@person).deliver
    end

    it "sends the remind email" do
      ActionMailer::Base.deliveries.length.should == 1

      message = ActionMailer::Base.deliveries.first
      message.subject.should =~ /Lunch on Tuesday\?/
      message.to.should == [@person.email]
      message.from.should == ["dine@lunchlottery.com"]
      message.body.to_s.should match /Hello/
      message.body.to_s.should match /http:\/\/lunchlottery\.com\/people/
    end
  end
end