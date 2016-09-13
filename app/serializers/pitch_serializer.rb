class PitchSerializer < ActiveModel::Serializer
  attributes :id, :name, :brief_date, :brief_email_contact, :skill_categories, :brand, :pitch_evaluations
end
