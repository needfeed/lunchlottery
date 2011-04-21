class PeopleController < ApplicationController
  
  def index
    @person = Person.new
    @people_count = Person.count
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:message] = "Cool, you're signed up!"
      redirect_to root_path
    else
      @people_count = Person.count
      render :template => "people/index"
    end
  end

  def show
    @person = Person.authenticate!(params[:token])
    flash[:message] = "Hey #{@person.email}!"
  end

end