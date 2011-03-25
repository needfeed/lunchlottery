class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email

  def self.all_emails
    Person.all.map &:email
  end
end
