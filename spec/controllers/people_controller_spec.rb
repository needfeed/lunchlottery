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
      lambda do
        post :create, :person => {:email => "me@example.com"}
      end.should change{Person.count}.by(1)

      response.should redirect_to(root_path)
      flash[:message].should_not be_nil
    end
    
    it "should render the form if there's a validation error" do
      lambda do
        post :create, :person => {:email => "me"}
      end.should_not change{Person.count}
      
      assigns(:people_count).should be_an(Integer)
      response.should be_success
      response.should render_template("people/index")
      response.body.should =~ /not valid/
    end
  end
end
