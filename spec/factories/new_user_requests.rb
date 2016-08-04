FactoryGirl.define do
  factory :new_user_request do
    email { FFaker::Internet.email }
    agency 'Pequeño Cuervo'
  end
end
