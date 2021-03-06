class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :brands, :contact_name, :contact_email, :contact_position, :logo, :favorite_agencies

  def favorite_agencies
    favs = []
    object.agencies.each do |fav|
      favs.push({:id => fav.id, :name => fav.name})
    end
    favs
  end
end
