require 'spec_helper'

describe Dates do
  describe "#next_tuesday" do
    it "works a while ago" do
      Timecop.freeze(DateTime.parse("2008-11-10 11:11:11 UTC")) do
        Dates.next_tuesday.should == DateTime.parse("2008-11-11 23:59:59 UTC")
      end
    end

    it "should return next tuesday" do
      Timecop.freeze(DateTime.parse("2011-11-11 11:11:11 UTC")) do
        Dates.next_tuesday.should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called on a tuesday" do
      Timecop.freeze(DateTime.parse("2011-11-15 11:11:11 UTC")) do
        Dates.next_tuesday.should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called on a wednesday" do
      Timecop.freeze(DateTime.parse("2011-11-09 11:11:11 UTC")) do
        Dates.next_tuesday.should == DateTime.parse("2011-11-15 23:59:59 UTC")
      end
    end

    it "works when called right before midnight" do
      Timecop.freeze(DateTime.parse("2011-11-08 23:58:59 UTC")) do
        Dates.next_tuesday.should == DateTime.parse("2011-11-08 23:59:59 UTC")
      end
    end

    it "should stringify to an ISO date" do
      Timecop.freeze(DateTime.parse("2011-11-08 23:58:59 UTC")) do
        Dates.next_tuesday.to_s.should == "2011-11-08T23:59:59+00:00"
      end
    end
  end
end