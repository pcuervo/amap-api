class NewUserRequestSerializer < ActiveModel::Serializer
  attributes :id, :user_type, :agency_brand, :email, :created_at
end
