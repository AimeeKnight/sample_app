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
  #if followers destroyed, so is relationship
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                     dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  before_save { email.downcase! }
  #forces uniqueness on the database level in case users submits in quick succession
  #before_save { |user| user.email.downcase! } #alternate syntax
  before_save :create_remember_token

  #validates method also creates error object for the specific instance
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } #matching emails will be invalid regradless of case
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true		
  after_validation { self.errors.messages.delete(:password_digest) }

  #called from static_pages controller, defined in Micropost model
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    #using explicit 'self' is matter of taste
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
