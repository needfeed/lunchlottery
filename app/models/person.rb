class Person < ActiveRecord::Base
  def self.all_emails
    Person.all.map &:email
  end
end
