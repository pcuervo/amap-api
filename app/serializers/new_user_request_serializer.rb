class NewUserRequestSerializer < ActiveModel::Serializer
  attributes :id, :user_type, :agency, :email
end
