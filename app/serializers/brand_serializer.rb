class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :contact_name, :contact_email, :contact_position, :company

  def company
    c = {}
    c[:id] = object.company.id
    c[:name] = object.company.name
    c
  end
end
