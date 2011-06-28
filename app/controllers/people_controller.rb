class PeopleController < ApplicationController
  def index
    @person = Person.new
    @people_count = Person.count
    @location = Location.find_by_name(params[:location])
  end

  def welcome
  end

  def create
    @location = Location.find_by_name(params[:location])
    if @location.nil?
      redirect_to root_path
      return
    end
    
    @person = Person.new(params[:person].merge(:location => @location))
    if @person.save
      flash[:message] = "Cool, you're signed up!"
      redirect_to location_path(@location)
    else
      @people_count = Person.count
      render :template => "people/index"
    end
  end

  def update
    @person = Person.find_by_authentication_token!(params[:token])
    
    if @person.update_attributes(params[:person])
      flash[:notice] = "Your settings have been updated."
    else
      flash[:error] = "I had a problem saving that."
    end

    render :edit
  end
end