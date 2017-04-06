class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :contact_name, :contact_email, :contact_position, :company, :created_at, :pitches

  def company
    c = {}
    c[:id] = object.company.id
    c[:name] = object.company.name
    c
  end
end
