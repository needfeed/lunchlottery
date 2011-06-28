class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email
  validates_presence_of :location

  before_create :generate_authentication_token

  belongs_to :location
  
  scope :opted_in, where(:opt_in => true)

  def self.find_by_authentication_token!(token)
    find_by_authentication_token(token) or raise "I couldn't find that token."
  end

  protected

  def generate_authentication_token
    loop do
      self.authentication_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', 'xyz')
      break unless self.class.find_by_authentication_token(self.authentication_token)
    end
  end
end
