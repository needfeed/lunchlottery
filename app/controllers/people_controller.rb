class PeopleController < ApplicationController
  def index
    @people_count = Person.count
  end

  def create
    Person.create!(params[:person])
    redirect_to root_path
  end
end