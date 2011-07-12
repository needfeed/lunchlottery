require 'spec_helper'

describe Lottery do
  describe ".send_invitations!" do
    before do
      @pivotal = Location.create!(:name => "pivotal", :address => "731 Market Street San Francisco, CA")
      @pivotal_people = new_people(7, @pivotal, true)
      @pivotal_people.first.opt_in = false
      @pivotal_people.each(&:save!)

      @storek = Location.create!(:name => "storek", :address => "149 9th Street San Francisco, CA")
      @storek_people = new_people(3, @storek, true)
      @storek_people.each(&:save!)

      Lottery.send_invitations!
    end

    it "invites groups of opted-in people" do
      (ActionMailer::Base.deliveries[0].to + ActionMailer::Base.deliveries[1].to).should =~ %w[
        pivotal_2@example.com pivotal_3@example.com pivotal_4@example.com
        pivotal_5@example.com pivotal_6@example.com pivotal_7@example.com
      ]
      
      ActionMailer::Base.deliveries[2].to.to_a.should =~ %w[
        storek_1@example.com storek_2@example.com storek_3@example.com
      ]
    end

    it "resets the opt-in flag" do
      Person.opted_in.length.should == 0
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