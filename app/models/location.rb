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
