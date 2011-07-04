require 'spec_helper'

describe Grouper do
  describe ".make_groups" do
    it "splits up 5 people" do
      Grouper.make_groups(new_people(5)).map(&:size).should == [5]
    end

    it "splits up 6 people into 2 groups of 3" do
      Grouper.make_groups(new_people(6)).map(&:size).should == [3, 3]
    end

    it "sends 2 emails to 8 people, in groups of 4" do
      Grouper.make_groups(new_people(8)).map(&:size).should == [4, 4]
    end

    it "splits up 9 people into 3 groups of 3" do
      Grouper.make_groups(new_people(9)).map(&:size).should == [3, 3, 3]
    end
  end
end