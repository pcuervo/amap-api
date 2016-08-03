class Agency < ApplicationRecord
  has_many :users

  validates :name, uniqueness: true
end
