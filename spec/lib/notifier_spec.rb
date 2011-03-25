require 'spec_helper'

describe Notifier do
  describe ".send_reminders" do
    def example_emails(count)
      (1..count).map { |i| "#{i}@example.com" }
    end
    
    before do
      @people = example_emails(8)
      Person.stub(:all_emails) { @people }
    end

    after do
      ActionMailer::Base.deliveries = []
    end

    context "when it's Monday" do
      before do
        monday = Date.parse("2011-03-21")
        Date.stub(:today) { monday }
      end

      it "should send 2 emails to 8 people, in groups of 4" do
        Notifier.send_reminders
        ActionMailer::Base.deliveries.collect { |message| message.to.length }.should == [4, 4]
      end

      it "should shuffle the people" do
        @people.should_receive(:shuffle!)
        Notifier.send_reminders
      end

      context "when one person would dine alone" do
        it "should split up the groups more evenly" do
          @people = example_emails(5)
          Notifier.send_reminders
          ActionMailer::Base.deliveries.collect { |message| message.to.length }.should == [3, 2]
        end
      end

      context "when two people would dine alone" do
        it "should split up the groups evenly" do
          @people = example_emails(6)
          Notifier.send_reminders
          ActionMailer::Base.deliveries.collect { |message| message.to.length }.should == [3, 3]
        end
      end

      context "when nine people are present" do
        it "should split into 3 groups of 3" do
          @people = example_emails(9)
          Notifier.send_reminders
          ActionMailer::Base.deliveries.collect { |message| message.to.length }.should == [3, 3, 3]
        end
      end
    end

    context "when it's not Monday" do
      before do
        wednesday = Date.parse("2011-03-30")
        Date.stub(:today) { wednesday }
      end

      it "should only send emails on Monday" do
        Notifier.send_reminders
        ActionMailer::Base.deliveries.length.should == 0
      end
    end
  end
end
