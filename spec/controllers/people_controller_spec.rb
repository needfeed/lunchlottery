require 'spec_helper'

describe PeopleController do
  describe "#index" do
    it "should get a list of user names" do
      get :index
      assigns(:people_count).should be_an(Integer)
    end
  end

  describe "#create" do
    it "should create a new person" do
      lambda do
        post :create, :person => {:email => "me@example.com"}
      end.should change{Person.count}.by(1)

      response.should redirect_to(root_path)
    end
  end
end
