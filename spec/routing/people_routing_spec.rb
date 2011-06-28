require "spec_helper"

describe PeopleController do

  let(:token) { create_person(:email => "foo@example.com").authentication_token }
  
  it "recognizes and generates #update" do
    person_token_path(token).should == "/people/#{token}"
    { :get => "/people/#{token}"}.should route_to(:controller => "people", :action => "update", :token => token)
  end

  it "passes the name of the location" do
    { :get => "/mylocation" }.should route_to(:controller => "people", :action => "index", :location => "mylocation")
  end

  it "goes to welcome action if no location" do
    { :get => "/" }.should route_to(:controller => "people", :action => "welcome")
  end
end