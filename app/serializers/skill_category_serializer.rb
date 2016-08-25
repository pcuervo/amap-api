class SkillCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :skills

  has_many :skills
end
