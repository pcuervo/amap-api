class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :is_member_amap, :auth_token, :agency_id, :brand_id

  def agency_id
    return -1 if object.agencies.empty?
    object.agencies.first.id
  end

  def brand_id
    return -1 if object.brands.empty?
    object.brands.first.id
  end
end
