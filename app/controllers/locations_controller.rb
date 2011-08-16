class LocationsController < ApplicationController
  def create
    @location = Location.new(params[:location])
    @location.save!

    redirect_to root_path
  rescue
    render :action => :new
  end

  def new
  end

end
