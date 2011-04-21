class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email

  before_create :generate_authentication_token

  def self.shuffled
    Person.all.shuffle
  end

  def self.send_invitations
    make_groups.each{|g| Notifier.invite(g) }
  end

  def self.send_reminders
    all.each{|p| Notifier.remind(p) }
  end

  def self.make_groups
    groups = []
    people = shuffled
    until people.empty?
      group_size = 4
      group_size = 3 if [5, 6, 9].include?(people.length)
      groups << people.slice!(0, group_size)
    end
    groups
  end

  def self.authenticate!(token)
    Person.where({ :authentication_token => token}).first or raise "InvalidToken"
  end

  protected

  def generate_authentication_token
    loop do
      self.authentication_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', 'xyz')
      break unless Person.where({ :authentication_token => self.authentication_token}).first
    end
  end

end
