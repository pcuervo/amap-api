class User < ApplicationRecord
  before_create :generate_authentication_token!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
          :rememberable, :trackable

  validates :role, 
              presence: true,
              inclusion: { in: [1, 2, 3, 4, 5], message: "%{value} is not a valid role" }
  validates :auth_token, uniqueness: true
  validates :email,   
              uniqueness: { :case_sensitive => true },
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, 
              :length => { :within => 6..40 }, 
              :on => :create,
              :confirmation => true
  # validates :password, 
  #             :length => { :within => 6..40 }, 
  #             :on => :update

  has_and_belongs_to_many :agencies
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :pitches
  has_many :pitch_evaluations
  has_many :user_tokens

  AMAP_ADMIN    = 1
  AGENCY_ADMIN  = 2
  AGENCY_USER   = 3
  CLIENT_ADMIN  = 4
  CLIENT_USER   = 5
  
  def generate_authentication_token!
    ## ADD TOKEN HERE
    begin
      self.auth_token = Devise.friendly_token
      UserToken.create( :user_id => self.id, :auth_token => self.auth_token )
    end while self.class.exists?(auth_token: auth_token)
  end

  def generate_password_reset_token!
    begin
      self.reset_password_token = Devise.friendly_token
    end while self.class.exists?(reset_password_token: reset_password_token)
  end

  def send_password_reset
    generate_password_reset_token!
    self.reset_password_sent_at = Time.now
    save!
    m = UserMailer.password_reset( self ).deliver_now
  end

  def self.generate_friendly_password agency_company
    return agency_company.gsub(' ', '_') + '_' + rand(10...99).to_s
  end
end
