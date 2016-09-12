class Pitch < ApplicationRecord
  validates :name, presence: true
  belongs_to :skill_category
  belongs_to :brand
  has_many :pitch_evaluations
end
