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

  def edit
    @person = Person.authenticate!(params[:token])
    flash[:message] = "Hey #{@person.email}!"
  end

  def update
    @person = Person.authenticate!(params[:token])
    if @person.update_attributes(params[:person])
      flash[:notice] = "Your settings have been updated."
    else
      flash[:error] = "I had a problem saving that."
    end

    redirect_to person_token_path(@person.authentication_token)
  end

end