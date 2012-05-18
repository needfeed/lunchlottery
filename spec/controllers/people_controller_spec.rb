require 'spec_helper'

describe PeopleController do
  describe "#index" do
    it "should get a count of people who have signed up" do
      location = Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA")
      new_people(2, location).map(&:save!)

      other_location = Location.create!(:name => "my_other_location", :address => "149 9th Street San Francisco, CA")
      new_people(3, other_location).map(&:save!)

      get :index, :location => "mylocation"
      assigns(:people_count).should == 2
      response.body.should =~ /Two people/
    end

    it "should redirect to welcome if the location doesn't exist" do
      get :index, :location => "badlocation"
      response.should redirect_to(root_path)
    end

    it "should show gravatars of people in the location" do
      location = Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA")
      people = new_people(2, location)
      people.map(&:save!)

      get :index, :location => "mylocation"
      Nokogiri::HTML(response.body).css("img.gravatar").map { |node| node.attr("src") }.should =~ people.map(&:gravatar_url)
    end

    it "should show people who are opted in above others" do
      location = Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA")
      opted_in_person = create_person(:email => "in@example.com", :opt_in_datetime => DateTime.parse("9999-11-11 11:11:11 UTC"), :location => location)
      non_opted_in_person = create_person(:email => "not_in@example.com", :opt_in_datetime => nil, :location => location)

      get :index, :location => "mylocation"

      assigns(:opted_in_people).map(&:gravatar_url).should == [opted_in_person.gravatar_url]
      assigns(:non_opted_in_people).map(&:gravatar_url).should == [non_opted_in_person.gravatar_url]

      Nokogiri::HTML(response.body).css(".opted_in img.gravatar").map { |node| node.attr("src") }.should =~ [opted_in_person.gravatar_url]
      Nokogiri::HTML(response.body).css(".non_opted_in img.gravatar").map { |node| node.attr("src") }.should =~ [non_opted_in_person.gravatar_url]
    end

    it "should mention the weekday" do
      Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA", :weekday => "Sunday")
      get :index, :location => "mylocation"
      response.body.should include "every Sunday"
      response.body.should include "Saturday night"
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
      Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA")

      expect {
        post :create, :person => { :email => "me@example.com" }, :location => "mylocation"
      }.to change(Person, :count).by(1)

      response.should redirect_to("/mylocation")
      flash[:message].should_not be_nil
    end

    it "should redirect to home if the location doesn't exist" do
      expect {
        post :create, :person => { :email => "me@example.com" }, :location => "badlocation"
      }.not_to change(Person, :count)

      response.should redirect_to("/")
      flash[:message].should be_nil
    end

    it "should render the form if the email is invalid" do
      location = Location.create!(:name => "mylocation", :address => "149 9th Street San Francisco, CA")
      new_people(2, location).map(&:save!)

      other_location = Location.create!(:name => "my_other_location",:address => "149 9th Street San Francisco, CA")
      new_people(3, other_location).map(&:save!)

      expect {
        post :create, :person => { :email => "me" }, :location => "mylocation"
      }.to change(Person, :count).by(0)

      assigns(:people_count).should == 2
      response.should be_success
      response.should render_template("people/index")
      response.body.should =~ /not valid/
    end
  end

  describe "#update" do
    let(:person) { create_person(:email => "foo@example.com") }

    context "with a valid token, setting opt_in_datetime false" do
      before { get :update, :token => person.authentication_token, :person => { :opt_in_datetime => "false" } }

      it { assigns(:person).should be_present }
      it { assigns(:changed_opt_in_datetime).should == true }
      it { response.should be_success }
      it { should render_template("people/edit") }
      it { flash[:notice].should match(/updated/) }

      it "persists the opt in param" do
        Person.find_by_id(person.id).should_not be_opt_in_datetime
      end

      it "renders a form for further updating update" do
        response.should have_selector("form", :action => person_token_path(person.authentication_token),
                                      :method => 'get')
      end

      it "renders a button to go if the person is currently not going" do
        person.should_not be_opt_in_datetime
        response.should have_selector("input", :type => 'submit', :value => "Actually, I want to go")
      end

      it "gives the message that the user is not going" do
        response.body.should include "not going"
      end
    end

    context "with a valid token, setting subscribed to false" do
      before do
        person.should be_subscribed
        get :update, :token => person.authentication_token, :person => { :subscribed => "false" }
      end

      it "sets the subscribed flag to false" do
        person.reload.should_not be_subscribed
      end

      it { assigns(:changed_subscription).should == true }

      it "give the message that the user has unsubscribed" do
        response.body.should include "unsubscribed"
      end
    end

    context "when the person is currently going" do
      before do
        future = DateTime.parse("9 Nov 2100 23:59")
        person_two = create_person(:email => "bar@example.com", :location => person.location, :opt_in_datetime => future)
        person_three = create_person(:email => "baz@example.com", :location => person.location, :opt_in_datetime => nil)
        person_four = create_person(:email => "joe@example.com", :location => Location.new(:name => "test_two", :address => "123 9th Street Boise, ID"))
        get :update, :token => person.authentication_token, :person => { :opt_in_datetime => future }
      end
      
      it "should render a button to not go" do
        person.reload.should be_going
        response.should have_selector("input", :type => 'submit', :value => "Actually, I don't want to go")
      end
      
      it "should render ALL of the people that have opted-in" do
        assigns(:people).map(&:email).should =~ ["foo@example.com", "bar@example.com"]
      end
      
      it "should render the actual gravatars of people opted-in" do
        Nokogiri::HTML(response.body).css("img.gravatar").map { |node| node.attr("src") }.should =~ assigns(:people).map(&:gravatar_url)
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
