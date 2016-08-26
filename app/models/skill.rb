class Skill < ApplicationRecord
  belongs_to :skill_category
  has_many :agency_skills
  has_many :agencies, :through => :agency_skills

  validates :name, uniqueness: true
  validates :name, presence: true
end
