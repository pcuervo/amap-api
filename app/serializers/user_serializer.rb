class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :is_member_amap, :agency

  has_one :agency
end
