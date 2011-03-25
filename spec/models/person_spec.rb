require 'spec_helper'

describe Person do
  before do
    Person.count.should == 0
  end
  
  describe ".all_emails" do
    it "returns all emails" do
      Person.create!(:email => "1@example.com")
      Person.create!(:email => "2@example.com")
      Person.count.should == 2
      Person.all_emails.should == ["1@example.com", "2@example.com"]
    end
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
end
