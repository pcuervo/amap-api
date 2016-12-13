class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :brands, :contact_name, :contact_email, :contact_position, :logo, :favorite_agencies

  def favorite_agencies
    favs = []
    object.favorite_agencies.each do |fav|
      agency = Agency.find(fav.agency_id)
      favs.push({:id => agency.id, :name => agency.name})
    end
    favs
  end
end
