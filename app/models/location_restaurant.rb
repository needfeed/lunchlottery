# == Schema Information
#
# Table name: location_restaurants
#
#  id            :integer         not null, primary key
#  location_id   :integer
#  restaurant_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class LocationRestaurant < ActiveRecord::Base
  belongs_to :location
  belongs_to :restaurant

end

