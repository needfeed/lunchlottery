require "spec_helper"

describe PeopleController do

  let(:token) { Person.create!(:email => "foo@example.com").authentication_token }
  
  it "recognizes and generates #update" do
    person_token_path(token).should == "/people/#{token}"
    { :get => "/people/#{token}"}.should route_to(:controller => "people", :action => "update", :token => token)
  end

end