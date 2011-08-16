class AddAddressToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :address, :string
    add_column :locations, :longitude, :float
    add_column :locations, :latitude, :float
  end

  def self.down
    remove_column :locations, :latitude
    remove_column :locations, :longitude
    remove_column :locations, :address
  end
end
