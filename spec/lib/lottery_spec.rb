require 'spec_helper'

describe Lottery do
  describe ".send_invitations!" do
    before do
      @people = new_people(7)
      @people.first.opt_in = false
      @people.each(&:save!)

      Lottery.send_invitations!
    end

    it "invites groups of opted-in people" do
      ActionMailer::Base.deliveries[0].to.length.should == 3
      ActionMailer::Base.deliveries[1].to.length.should == 3
    end

    it "resets the opt-in flag" do
      Person.opted_in.length.should == 7
    end
  end

  describe ".send_reminders!" do
    before do
      create_person(:email => "foo@example.com")
      create_person(:email => "foo2@example.com", :opt_in => false)
    end

    it "sends the reminder to everyone" do
      Lottery.send_reminders!
      Person.count.should == 2
      ActionMailer::Base.deliveries.length.should == 2
    end
  end
end