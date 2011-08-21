require 'spec_helper'

describe RestaurantsController do

  describe "#create" do
    it "should be successful & redirect to people#index " do
      location = Location.create!(:name => "location", :address => "100 Market St., San Francisco, CA")
      post :create, :location_id => location.to_param, :restaurant => { :name => "Taco Mall", :address => "300 Market St., San Francisco, CA" }

      created_restaurant = Restaurant.find_by_name("Taco Mall")
      created_restaurant.should_not be_nil
      location.restaurants.reload.should include(created_restaurant)

      response.should redirect_to location_path(location)
    end
  end
end
