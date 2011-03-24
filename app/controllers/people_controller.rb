class PeopleController < ApplicationController
  def index
    @people = YAML.load_file("#{Rails.root}/config/people.yml")
  end
end