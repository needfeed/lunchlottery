class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email

  before_create :generate_authentication_token
  
  scope :opted_in, where(:opt_in => true)

  def self.send_invitations
    groups = make_groups(Person.opted_in.all.shuffle)
    groups.each do |group|
      Notifier.invite(group).deliver
    end

    Person.update_all :opt_in => true
  end

  def self.send_reminders
    Person.all.each do |person|
      Notifier.remind(person).deliver
    end
  end

  def self.make_groups(items)
    groups = []
    until items.empty?
      size = 4
      size = 3 if [5, 6, 9].include?(items.length)
      groups << items.slice!(0, size)
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
