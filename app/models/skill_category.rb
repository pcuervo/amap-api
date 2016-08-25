class SkillCategory < ApplicationRecord
  has_many :skills

  validates :name, uniqueness: true
  validates :name, presence: true
end
