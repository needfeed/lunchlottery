require 'spec_helper'

describe Lottery do
  describe ".send_invitations!" do
    context "with groups" do
      before do
        @pivotal = Location.create!(:name => "pivotal", :address => "731 Market Street San Francisco, CA")
        @pivotal_people = new_people(7, @pivotal, "2100-11-02 23:59")
        @pivotal_people.first.opt_in_datetime = nil
        @pivotal_people.each(&:save!)

        @storek = Location.create!(:name => "storek", :address => "149 9th Street San Francisco, CA")
        @storek_people = new_people(3, @storek, "2100-11-02 23:59")
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

      it "does not reset the opt-in flag yet" do
        Person.opted_in.length.should == 9
      end

    end

    it "does not send invites to those who have unsubscribed" do
      @storek = Location.create!(:name => "storek", :address => "149 9th Street San Francisco, CA")

      create_person(:email => "quuxNope@example.com", :subscribed => false, :opt_in_datetime => "2100-11-02 23:59", :location => @storek)
      create_person(:email => "quux1@example.com", :subscribed => true, :opt_in_datetime => "2100-11-02 23:59", :location => @storek)
      create_person(:email => "quux2@example.com", :subscribed => true, :opt_in_datetime => "2100-11-02 23:59", :location => @storek)
      create_person(:email => "quux3@example.com", :subscribed => true, :opt_in_datetime => "2100-11-02 23:59", :location => @storek)
      Lottery.send_invitations!
      group_mail_deliveries = ActionMailer::Base.deliveries
      grouped_emails = group_mail_deliveries.map(&:to)
      grouped_emails.flatten.should_not include("quuxNope@example.com")
    end
  end
  
  it "doesn't send an invitation if a group has less than 3 people" do
    location = Location.create!(:name => "yelp", :address => "1 Market Street")
    new_people(2, location, "2100-11-02 23:59").each(&:save!)
    
    Lottery.send_invitations!
    ActionMailer::Base.deliveries.should be_empty
  end

  describe ".send_reminders!" do
    before do
      create_person(:email => "foo@example.com")
      create_person(:email => "foo2@example.com", :opt_in_datetime => nil)
    end

    it "sends the reminder to everyone" do
      Lottery.send_reminders!
      Person.count.should == 2
      ActionMailer::Base.deliveries.length.should == 2
    end

    it "does not send reminders to those who have unsubscribed" do
      create_person(:email => "quux@example.com", :subscribed => false)
      Lottery.send_reminders!
      ActionMailer::Base.deliveries.length.should == 2
    end
  end
end