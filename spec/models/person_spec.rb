require 'spec_helper'

describe Person do

  before do
    Person.count.should == 0
  end

  describe "validations" do
    it "requires email to look like an email address" do
      Person.new(:email => "i dont know my email address").should_not be_valid
    end

    it "requires email to be present" do
      Person.new(:email => nil).should_not be_valid
    end

    it "requires email to be unique" do
      Person.create!(:email => "me@example.com")
      Person.new(:email => "me@example.com").should_not be_valid
    end
  end

  describe ".send_invitations" do
    it "sends the reminder to everyone" do
      groups = [stub_people(2), stub_people(2)]
      Person.stub!(:make_groups) { groups }
      groups.each {|g| Notifier.should_receive(:invite).with(g).once }
      Person.send_invitations
    end
  end

  describe ".send_reminders" do
    it "sends the reminder to everyone" do
      Person.all.each {|p| Notifier.should_receive(:remind).with(p).once }
      Person.send_reminders
    end
  end

  describe ".make_groups" do
    it "sends 2 emails to 8 people, in groups of 4" do
      mock_people
      Person.make_groups.map {|g| g.size }.should == [4, 4]
    end

    it "splits up 5 people into 2 groups" do
      mock_people(5)
      Person.make_groups.map {|g| g.size }.should == [3, 2]
    end

    it "splits up 6 people into 2 groups of 3" do
      mock_people(6)
      Person.make_groups.map {|g| g.size }.should == [3, 3]
    end

    it "splits up 9 people into 3 groups of 3" do
      mock_people(9)
      Person.make_groups.map {|g| g.size }.should == [3, 3, 3]
    end
  end

end
