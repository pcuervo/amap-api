FactoryGirl.define do
  factory :new_user_request do
    email     { FFaker::Internet.email }
    agency_brand    'Pequeño Cuervo'
    user_type 2
  end
end
