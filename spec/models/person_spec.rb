require 'spec_helper'

describe Person do

  before do
    Person.count.should == 0
  end

  describe "validations" do
    it "requires email to look like an email address" do
      Person.new(:email => "i dont know my email address").should_not be_valid
    end

    it "requires email to be present" do
      Person.new(:email => nil).should_not be_valid
    end

    it "requires email to be unique" do
      Person.create!(:email => "me@example.com")
      Person.new(:email => "me@example.com").should_not be_valid
    end
  end

  describe ".send_invitations" do
    it "only invites opted in people" do
      Person.should_receive(:opted_in).once.and_return(Person.scoped)
      Person.send_invitations
    end

    it "invites the grouped people" do
      @groups = [new_people(2), new_people(2)]
      Person.stub!(:make_groups).and_return(@groups)
      
      Person.send_invitations
      ActionMailer::Base.deliveries.length.should == @groups.count
    end
  end

  describe ".send_reminders" do
    before do
      Person.create!(:email => "foo@example.com")
    end  

    it "sends the reminder to everyone" do
      Person.send_reminders
      Person.count.should_not be_zero
      ActionMailer::Base.deliveries.length.should == Person.count
    end
  end

  describe ".make_groups" do
    it "sends 2 emails to 8 people, in groups of 4" do
      mock_people
      Person.make_groups.map {|g| g.size }.should == [4, 4]
    end

    it "splits up 5 people into 2 groups" do
      mock_people(5)
      Person.make_groups.map {|g| g.size }.should == [3, 2]
    end

    it "splits up 6 people into 2 groups of 3" do
      mock_people(6)
      Person.make_groups.map {|g| g.size }.should == [3, 3]
    end

    it "splits up 9 people into 3 groups of 3" do
      mock_people(9)
      Person.make_groups.map {|g| g.size }.should == [3, 3, 3]
    end
  end

  describe "#authentication_token" do
    let(:user) { Person.create!(:email => "foo@example.com") }

    it "generates a uuid for the user" do
      user.authentication_token.should =~ /^\w{20}$/
    end

    it "persists the token" do
      token = user.authentication_token
      Person.find_by_id(user.id).authentication_token.should == token
    end
  end

  describe ".find_by_authentication_token!" do
    let(:user) { Person.create!(:email => "foo@example.com") }

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
end
