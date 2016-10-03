class Company < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :brands

  validates :name, presence: true
end
