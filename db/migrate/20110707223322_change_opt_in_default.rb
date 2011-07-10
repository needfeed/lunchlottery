class ChangeOptInDefault < ActiveRecord::Migration
  def self.up
    change_column_default :people, :opt_in, false
  end

  def self.down
    change_column_default :people, :opt_in, true
  end
end
