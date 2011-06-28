require 'spec_helper'

describe Location do
  it "should use the name as the to_param" do
    Location.new(:name => "name").to_param.should == "name"
  end
end
