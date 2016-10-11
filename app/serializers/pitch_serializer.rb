class PitchSerializer < ActiveModel::Serializer
  attributes :id, :name, :brief_date, :brief_email_contact, :skill_categories, :company, :brand, :pitch_evaluations

  def company
    object.brand.company.name
  end
end
