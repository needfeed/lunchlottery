require 'spec_helper'

describe Person do
  describe ".all_emails" do
    it "returns all emails" do
      Person.delete_all
      Person.count.should == 0
      Person.create!(:email => "1@example.com")
      Person.create!(:email => "2@example.com")
      Person.count.should == 2
      Person.all_emails.should == ["1@example.com", "2@example.com"]
    end
  end
end
