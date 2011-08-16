require 'spec_helper'

describe LocationsController do
  describe "POST 'create'" do
    it "creates a location" do
      post :create, :location => {:name => "Here", :meeting_point => "12:30 at the elevators", :address => "1 Market Street"}
      response.should redirect_to(root_path)

      location = Location.first
      location.should be_present
      location.name.should == "Here"
      location.meeting_point.should == "12:30 at the elevators"
      location.address.should == "1 Market Street"
    end
  end

  describe "GET 'new'" do
    it "shows a form" do
      get 'new'
      response.should be_success
    end
  end
end