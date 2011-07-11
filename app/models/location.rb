 class Location < ActiveRecord::Base
  has_many :people
  has_many :location_restaurants
  has_many :restaurants, :through => :location_restaurants

  def to_param
    name
  end
end
