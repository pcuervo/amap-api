class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :brands, :contact_name, :contact_email, :contact_position, :logo

  def logo
    object.logo(:thumb)
  end
end
