class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email

  before_create :generate_authentication_token
  
  scope :opted_in, where(:opt_in => true)

  def self.shuffled
    Person.all.shuffle
  end

  def self.send_invitations
    opted_in.make_groups.each { |group| Notifier.invite(group).deliver }
    Person.update_all :opt_in => true
  end

  def self.send_reminders
    all.each { |person| Notifier.remind(person).deliver }
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

  def self.find_by_authentication_token!(token)
    Person.where(:authentication_token => token).first or raise "I couldn't find that token."
  end

  protected

  def generate_authentication_token
    loop do
      self.authentication_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', 'xyz')
      break unless Person.where(:authentication_token => self.authentication_token).first
    end
  end
end
