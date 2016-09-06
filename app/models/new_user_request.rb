class NewUserRequest < ApplicationRecord
  validates :email, :agency_brand, presence: true
  validates :email, uniqueness: { :case_sensitive => true }

end
