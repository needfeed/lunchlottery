class AddWeekdayToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :weekday, :string, default: "Tuesday"
  end

  def self.down
    remove_column :locations, :weekday
  end
end
