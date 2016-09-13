class SkillCategory < ApplicationRecord
  has_many :skills
  has_and_belongs_to_many :pitches, :through => :pitches_skill_categories

  validates :name, uniqueness: true
  validates :name, presence: true
end
