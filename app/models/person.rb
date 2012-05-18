# == Schema Information
#
# Table name: people
#
#  id                   :integer         not null, primary key
#  email                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  authentication_token :string(255)
#  location_id          :integer
#  subscribed           :boolean         default(TRUE)
#  opt_in_datetime      :datetime
#

class Person < ActiveRecord::Base
  validates :email, :email => true
  validates_uniqueness_of :email
  validates_presence_of :location

  before_create :generate_authentication_token

  belongs_to :location
  
  scope :opted_in, where("opt_in_datetime IS NOT null and opt_in_datetime >= ?", DateTime.now)
  scope :subscribed, where(:subscribed => true)

  def self.find_by_authentication_token!(token)
    find_by_authentication_token(token) or raise "I couldn't find that token."
  end

  def going?
    Person.opted_in.where(:id => self).exists?
  end

  def gravatar_url
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "http://www.gravatar.com/avatar/#{hash}?s=50"
  end

  protected

  def generate_authentication_token
    loop do
      self.authentication_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', 'xyz')
      break unless self.class.find_by_authentication_token(self.authentication_token)
    end
  end
end

