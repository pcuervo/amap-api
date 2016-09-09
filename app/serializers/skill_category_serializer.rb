class SkillCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :skills, :created_at

  has_many :skills
end
