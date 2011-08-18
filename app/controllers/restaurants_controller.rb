class RestaurantsController < ApplicationController

  def new
    @location = Location.find_by_name(params[:location_id])
  end

  def create
    @location = Location.find_by_name(params[:location_id])
    @location.restaurants.create!(params[:restaurant])
    redirect_to location_path(@location)
  end


end