class User < ApplicationRecord
  before_create :generate_authentication_token!

  validates :email, :role, presence: true
  validates :role, inclusion: { in: [1, 2, 3, 4, 5], message: "%{value} is not a valid role" }
  validates :auth_token, uniqueness: true
  validates :email, uniqueness: { :case_sensitive => true }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :agency

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end
