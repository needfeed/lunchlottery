class PeopleController < ApplicationController
  before_filter :load_location, :only => [:index, :create]
  
  def index
    @person = Person.new
    @people = @location.people
    @people_count = @people.count
  end

  def welcome
  end

  def create
    @person = Person.new(params[:person].merge(:location => @location))
    if @person.save
      flash[:message] = "Cool, you're signed up!"
      redirect_to location_path(@location)
    else
      @people = @location.people
      @people_count = @people.count
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

    @changed_opt_in = params[:person].has_key?(:opt_in)
    @changed_subscription = params[:person].has_key?(:subscribed)
    @people = Person.opted_in.where(:location_id => @person.location_id)
    
    render :edit
  end
  
  def load_location
    @location = Location.find_by_name(params[:location])
    if @location.nil?
      redirect_to root_path
      return
    end
  end
end