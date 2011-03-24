class PeopleController < ApplicationController
  def index
    @people = YAML.load_file("#{Rails.root}/config/people.yml")
  end

  def create
    Person.create!(params[:person])
    redirect_to root_path
  end
end