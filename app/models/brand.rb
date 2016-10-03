class Brand < ApplicationRecord
  belongs_to :company
  has_many :pitches

  validates :name, presence: true
end
