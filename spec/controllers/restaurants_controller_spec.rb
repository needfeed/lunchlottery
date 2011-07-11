require 'spec_helper'

describe RestaurantsController do

  it "should route properly" do
    { :get => "/restaurants"}.should route_to({:controller => "restaurants", :action => "index"})
  end

  describe "#index" do
    it "should be successful & show a list of restaurants" do
      restaurant = Restaurant.create(:name => "Basil", :address => "42 Folsom Street San Francisco, CA")
      get :index
      assigns[:restaurants] = [restaurant]
      response.should be_success
    end
  end
end
