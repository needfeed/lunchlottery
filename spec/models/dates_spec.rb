require 'spec_helper'

describe Dates do
  describe "#next_occurrence" do
    it "works a while ago" do
      Timecop.freeze(DateTime.parse("2008-11-10 11:11:11 UTC")) do
        Dates.next_occurrence('Tuesday').should == DateTime.parse("2008-11-11 23:59:59 UTC")
      end
    end

    it "should return next tuesday" do
      Timecop.freeze(DateTime.parse("2011-11-11 11:11:11 UTC")) do
        Dates.next_occurrence('Tuesday').should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called on a tuesday" do
      Timecop.freeze(DateTime.parse("2011-11-15 11:11:11 UTC")) do
        Dates.next_occurrence('Tuesday').should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called on a wednesday" do
      Timecop.freeze(DateTime.parse("2011-11-09 11:11:11 UTC")) do
        Dates.next_occurrence('Tuesday').should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called right before midnight" do
      Timecop.freeze(DateTime.parse("2011-11-08 23:58:59 UTC")) do
        Dates.next_occurrence('Tuesday').should == DateTime.parse("2011-11-08 23:59:59 UTC")
      end
    end

    it "should stringify to an ISO date" do
      Timecop.freeze(DateTime.parse("2011-11-08 23:58:59 UTC")) do
        Dates.next_occurrence('Tuesday').to_s.should == "2011-11-08T23:59:59+00:00"
      end
    end
  end

  describe "#day_before" do
    it "takes a day name and return the name of the previous day" do
      Dates.day_before("Friday").should == "Thursday"
      Dates.day_before("Sunday").should == "Saturday"
    end
  end
end