require "spec_helper"

describe GroupingEvaluator do
  before do
    @history = [
      [[:p1, :p2, :p3, :p4],[:p5, :p6, :p7]],
      [[:p1, :p2, :p3, :p4],[:p5, :p6, :p7]]
    ]
  end

  describe ".compare" do
    it "counts the number of people who went out with each other last time" do
      GroupingEvaluator.compare(@history[0], @history[1]).should == (1 * 3) * 4 + (1 * 2) * 3
    end
  end

  describe "hashify" do
    it "takes the history array and converts it to awesome" do
      GroupingEvaluator.hashify(@history.first).should == {
        :p1 => [:p2, :p3, :p4],
        :p2 => [:p1, :p3, :p4],
        :p3 => [:p1, :p2, :p4],
        :p4 => [:p1, :p2, :p3],
        :p5 => [:p6, :p7],
        :p6 => [:p5, :p7],
        :p7 => [:p5, :p6]
      }
    end
  end
end