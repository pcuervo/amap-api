class Skill < ApplicationRecord
  belongs_to :skill_category

  validates :name, uniqueness: true
  validates :name, presence: true
end
