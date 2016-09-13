class Pitch < ApplicationRecord
  belongs_to :brand
  has_many :pitch_evaluations
  has_and_belongs_to_many :skill_categories, :through => :pitches_skill_categories

  validates :name, presence: true
end
