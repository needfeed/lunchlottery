require 'spec_helper'

describe PeopleController do
  it "should get a list of user names" do
    get :index
    assigns(:people).should be_a(Array)
  end

end
