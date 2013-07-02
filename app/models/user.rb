# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy

  before_save { email.downcase! }
  #forces uniqueness on the database level in case users submits in quick succession
  # before_save { |user| user.email.downcase! } #alternate syntax
  before_save :create_remember_token
  # before saving, creates a remember token attribute

  #validates method also creates error object for the specific instance
  validates :name,  presence: true, length: { maximum: 50 } #Rails validates the presence of an attribute using the blank? method
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } #matching emails will be invalid regradless of case
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true		
  after_validation { self.errors.messages.delete(:password_digest) }

  #called from static_pages controller
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private #below is hidden from instances

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
