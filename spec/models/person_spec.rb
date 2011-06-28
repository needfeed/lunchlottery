require 'spec_helper'

describe Person do
  before do
    Person.all.should be_empty
  end

  describe "validations" do
    it "requires email to look like an email address" do
      Person.new(:email => "i dont know my email address").should_not be_valid
    end

    it "requires email to be present" do
      Person.new(:email => nil).should_not be_valid
    end

    it "requires email to be unique" do
      create_person(:email => "me@example.com")
      Person.new(:email => "me@example.com").should_not be_valid
    end
  end

  describe "#authentication_token" do
    let(:user) { create_person(:email => "foo@example.com") }

    it "generates a uuid for the user" do
      user.authentication_token.should =~ /^\w{20}$/
    end

    it "persists the token" do
      token = user.authentication_token
      Person.find_by_id(user.id).authentication_token.should == token
    end
  end

  describe ".find_by_authentication_token!" do
    let(:user) { create_person(:email => "foo@example.com") }


    context "with a valid token" do
      it "returns the user" do
        Person.find_by_authentication_token!(user.authentication_token).should == user
      end
    end

    context "with an invalid token" do
      it "throws an authentication failed error" do
        expect { Person.find_by_authentication_token!("DEADBEEF") }.to raise_error
      end
    end
  end

  describe "location" do
    it "should have a location" do
      location = Location.create!(:name => "pivotal")
      create_person(:email => "asdf@example.com", :location => location)
      Person.find_by_email("asdf@example.com").location.should == Location.find_by_name("pivotal")
    end

    it "should require a location" do
      person = Person.new(:email => "asdf@example.com")
      person.should_not be_valid
      person.location = Location.new
      person.should be_valid
    end
  end


end
