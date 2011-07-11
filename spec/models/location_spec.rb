require 'spec_helper'

describe Location do

  it "should use the name as the to_param" do
    Location.new(:name => "name").to_param.should == "name"
  end

  it "should have many restaurants" do
    location = Location.create(:name => "amys house")
    restaurant = Restaurant.create(:name => "Basil", :address => "123 Folsom Street San Francisco, CA")
    location_restaurant = LocationRestaurant.create(:location => location, :restaurant => restaurant)
    location.restaurants.should == [restaurant]
  end
end
