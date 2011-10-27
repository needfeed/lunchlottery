class AddSubscribedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :subscribed, :boolean, :default => true
  end

  def self.down
    remove_column :people, :subscribed
  end
end
