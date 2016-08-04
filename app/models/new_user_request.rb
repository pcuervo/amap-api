class NewUserRequest < ApplicationRecord
  validates :email, :agency, presence: true
  validates :email, uniqueness: { :case_sensitive => true }
end
