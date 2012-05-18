# == Schema Information
#
# Table name: restaurants
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  address    :string(255)
#  longitude  :float
#  latitude   :float
#  created_at :datetime
#  updated_at :datetime
#

class Restaurant < ActiveRecord::Base
  validates_presence_of :name, :address

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end

