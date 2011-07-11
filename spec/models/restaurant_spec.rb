require 'spec_helper'

describe Restaurant do


  it { should validate_presence_of :name}
  it { should validate_presence_of :address }


  it "should geocode after save" do
    r = Restaurant.new(:name => "Basil", :address => "1175 Folsom St San Francisco, CA")
    r.latitude.should be_nil
    r.longitude.should be_nil
    r.save
    r.reload.latitude.should_not be_nil
    r.reload.longitude.should_not be_nil
  end

end
