class ChangeOptInToDate < ActiveRecord::Migration
  class Person < ActiveRecord::Base
  end

  def self.up
    add_column :people, :opt_in_datetime, :datetime
    Person.update_all(["opt_in_datetime = ?", DateTime.parse("15 Nov 2011 23:59")], {:opt_in => true})
    remove_column :people, :opt_in
  end

  def self.down
    add_column :people, :opt_in, :boolean
    puts "after a down migration, no one is considered opted in"
    remove_column :people, :opt_in_datetime
  end
end
