class LocationRestaurant < ActiveRecord::Base
  belongs_to :location
  belongs_to :restaurant

end
