class Location < ActiveRecord::Base
  has_many :people

  def to_param
    name
  end
end
