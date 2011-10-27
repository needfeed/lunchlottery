require 'spec_helper'

describe Location do

  it { should validate_presence_of :address}

  it "should use the name as the to_param" do
    Location.new(:name => "name").to_param.should == "name"
  end

  it "should have many restaurants" do
    location = Location.create(:name => "amys house", :address => "123 Bay Street San Francisco, CA")
    restaurant = Restaurant.create(:name => "Basil", :address => "123 Folsom Street San Francisco, CA")
    location_restaurant = LocationRestaurant.create(:location => location, :restaurant => restaurant)
    location.restaurants.should == [restaurant]
  end

  it "should save the lat/long after validation" do
    location = Location.new(:name => "Storek", :address => "149 9th Street San Francisco, CA")
    location.latitude.should be_nil
    location.longitude.should be_nil
    location.save
    location.reload.latitude.should == 37.77572
    location.reload.longitude.should == -132.0841430
  end
end
