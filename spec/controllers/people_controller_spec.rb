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

  describe "#edit" do
    context "with a valid token" do
      let(:person) { Person.create!(:email => "foo@example.com") }
      before { get :edit, :token => person.authentication_token }
      it { assigns(:person).should be_present }
      it { response.should be_success }
      it { should render_template("people/edit") }
      it "renders a form for the update" do
        response.should have_selector("form[action='#{person_token_path(person.authentication_token)}']")
      end
    end

    context "with an invalid token" do
      before { get :edit, :token => "this_is_a_nonexistant_token" }
      it { assigns(:person).should_not be_present }
      it { should render_template("application/error") }
      it { flash[:error].should match(/i couldn't find/i) }
    end
  end

  describe "#update" do
    let(:person) {  Person.create!(:email => "foo@example.com", :opt_in => true) }

    context "setting false" do
      before { put :update, :token => person.authentication_token, :person => {:opt_in => "false" } }
      it { assigns(:person).should be_present }
      it { response.should redirect_to "/people/#{person.authentication_token}" }
      it { flash[:notice].should match(/updated/) }
      it "persists the opt in param" do
        Person.find_by_id(person.id).should_not be_opt_in
      end
    end

    context "with an invalid token" do
      before { put :update, :token => "this_is_a_nonexistant_token" }
      it { assigns(:person).should_not be_present }
      it { should render_template("application/error") }
      it { flash[:error].should match(/i couldn't find/i) }
    end
  end
end
