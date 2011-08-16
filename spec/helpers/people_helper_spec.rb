require 'spec_helper'

describe PeopleHelper do

  describe "#google_map_url" do
    it "should create a link with all of the restaurant markers" do
      location = Location.create!(:name => "Storek", :address => "149 9th Street San Francisco, CA", :longitude => -122.413628, :latitude => 37.77572)
      restaurant_a = Restaurant.create(:name => "Basil", :address => "1175 Folsom Street San Francisco, CA", :longitude => -122.4114714, :latitude => 37.7738853)
      LocationRestaurant.create(:location => location, :restaurant => restaurant_a)

      restaurant_b = Restaurant.create(:name => "Bossa Nova", :address => "139 8th St San Francisco, CA", :longitude => -122.4126057, :latitude => 37.7770434)
      LocationRestaurant.create(:location => location, :restaurant => restaurant_b)

      helper.google_map_url(location).should == <<-BEGIN.gsub(/\s/, "")
        http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&
        markers=color:green%7Clabel:%7C#{location.latitude}%2C#{location.longitude}&
        markers=color:red%7Clabel:A%7C#{restaurant_a.latitude}%2C#{restaurant_a.longitude}&
        markers=color:red%7Clabel:B%7C#{restaurant_b.latitude}%2C#{restaurant_b.longitude}
      BEGIN
    end
  end

  describe "#google_map_pin_label" do

    it "should pick a label from A-Z" do
      helper.google_map_pin_label(0).should == "A"
      helper.google_map_pin_label(1).should == "B"
    end

    it "should wrap around if we run out of capital letters" do
      helper.google_map_pin_label(26).should == "A"
    end
  end
end