class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :agency, :is_member_amap
end
