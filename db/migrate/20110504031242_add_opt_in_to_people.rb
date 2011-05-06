class AddOptInToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :opt_in, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :people, :opt_in
  end
end
