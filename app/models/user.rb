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

  before_save { email.downcase! } #forces uniqueness on the database level in case users submits in quick succession

  #validates method also creates error object for the specific instance
  validates :name,  presence: true, length: { maximum: 50 } #Rails validates the presence of an attribute using the blank? method
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } #matching emails will be invalid regradless of case
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true		
  after_validation { self.errors.messages.delete(:password_digest) }

end
