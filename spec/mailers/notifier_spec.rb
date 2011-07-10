require 'spec_helper'

describe Notifier do
  describe ".remind" do
    before do
      @person = create_person(:email => "foo@example.com")
      Notifier.remind(@person).deliver
    end

    it "sends the remind email" do
      ActionMailer::Base.deliveries.length.should == 1

      message = ActionMailer::Base.deliveries.first
      message.subject.should =~ /Lunch on Tuesday\?/
      message.to.should == [@person.email]
      message.from.should == ["dine@lunchlottery.com"]
      message.body.to_s.should match /Hello/
      message.body.to_s.should include person_token_url(@person.authentication_token, :person => {:opt_in => true})
      message.body.to_s.should match /http:\/\/lunchlottery\.com\/people/
    end
  end

  describe ".invite" do
    before do
      @location = Location.new(:name => "mylocation", :meeting_point => "at the door")
      @people = new_people(8, @location)
      Notifier.invite(@people, @location ).deliver
    end

    it "sends the invite email" do
      ActionMailer::Base.deliveries.length.should == 1

      message = ActionMailer::Base.deliveries.first
      message.subject.should =~ /Your lunch tomorrow/
      message.to.should == @people.collect(&:email)
      message.from.should == ["dine@lunchlottery.com"]
      message.body.to_s.should match /Hello/
      message.body.to_s.should match /gravatar/
      message.body.to_s.should match /at the door/
    end
  end
end