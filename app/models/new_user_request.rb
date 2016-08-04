class NewUserRequest < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: { :case_sensitive => true }
end
