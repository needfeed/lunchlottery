class Person < ActiveRecord::Base
  validates :email, :email => true

  def self.all_emails
    Person.all.map &:email
  end
end
