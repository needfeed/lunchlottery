require 'spec_helper'

describe PeopleController do
  describe "#index" do
    it "should get a count of people who have signed up" do
      location = Location.create!(:name => "mylocation")
      new_people(2, location).map(&:save!)

      other_location = Location.create!(:name => "my_other_location")
      new_people(3, other_location).map(&:save!)

      get :index, :location => "mylocation"
      assigns(:people_count).should == 2
      response.body.should =~ /Two people/
    end
  end

  describe "#welcome" do
    it "should succeed" do
      get :welcome
      response.should be_success
    end
  end

  describe "#create" do
    it "should create a new person" do
      Location.create!(:name => "mylocation")

      expect {
        post :create, :person => {:email => "me@example.com"}, :location => "mylocation"
      }.to change(Person, :count).by(1)

      response.should redirect_to("/mylocation")
      flash[:message].should_not be_nil
    end
    
    it "should redirect to home if the location doesn't exist" do
      expect {
        post :create, :person => {:email => "me@example.com"}, :location => "badlocation"
      }.not_to change(Person, :count)

      response.should redirect_to("/")
      flash[:message].should be_nil
    end

    it "should render the form if the email is invalid" do
      location = Location.create!(:name => "mylocation")
      new_people(2, location).map(&:save!)

      other_location = Location.create!(:name => "my_other_location")
      new_people(3, other_location).map(&:save!)

      expect {
        post :create, :person => {:email => "me"}, :location => "mylocation"
      }.to change(Person, :count).by(0)
      
      assigns(:people_count).should == 2
      response.should be_success
      response.should render_template("people/index")
      response.body.should =~ /not valid/
    end
  end

  describe "#update" do
    let(:person) { create_person(:email => "foo@example.com") }

    context "with a valid token, setting false" do
      before { get :update, :token => person.authentication_token, :person => {:opt_in => "false" } }

      it { assigns(:person).should be_present }
      it { response.should be_success }
      it { should render_template("people/edit") }
      it { flash[:notice].should match(/updated/) }
      
      it "persists the opt in param" do
        Person.find_by_id(person.id).should_not be_opt_in
      end
      
      it "renders a form for further updating update" do
        response.should have_selector("form", :action => person_token_path(person.authentication_token),
                                              :method => 'get')
      end
    end
    
    context "with an invalid token" do
      before { get :update, :token => "this_is_a_nonexistent_token" }
      it { assigns(:person).should_not be_present }
      it { should render_template("application/error") }
      it { flash[:error].should match(/i couldn't find/i) }
    end
  end

end
