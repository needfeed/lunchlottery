require 'spec_helper'

describe PeopleController do
  describe "#index" do
    it "should get a list of user names" do
      get :index
      assigns(:people_count).should be_an(Integer)
      response.body.should =~ /Zero people/
    end
  end

  describe "#create" do
    it "should create a new person" do
      expect {
        post :create, :person => {:email => "me@example.com"}
      }.to change(Person, :count).by(1)

      response.should redirect_to(root_path)
      flash[:message].should_not be_nil
    end
    
    it "should render the form if there's a validation error" do
      expect {
        post :create, :person => {:email => "me"}
      }.to change(Person, :count).by(0)
      
      assigns(:people_count).should be_an(Integer)
      response.should be_success
      response.should render_template("people/index")
      response.body.should =~ /not valid/
    end
  end
end
