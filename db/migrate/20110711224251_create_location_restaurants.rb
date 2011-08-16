class CreateLocationRestaurants < ActiveRecord::Migration
  def self.up
    create_table :location_restaurants do |t|
      t.integer :location_id
      t.integer :restaurant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_restaurants
  end
end
