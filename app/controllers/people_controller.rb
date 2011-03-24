class PeopleController < ApplicationController
  def index
    @people = Person.all_emails
  end

  def create
    Person.create!(params[:person])
    redirect_to root_path
  end
end