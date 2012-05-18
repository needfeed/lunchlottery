# == Schema Information
#
# Table name: locations
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  meeting_point :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  address       :string(255)
#  longitude     :float
#  latitude      :float
#  weekday       :string(255)
#

 class Location < ActiveRecord::Base
  has_many :people
  has_many :location_restaurants
  has_many :restaurants, :through => :location_restaurants
  validates_presence_of :address

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def to_param
    name
  end
end

