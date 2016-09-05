FactoryGirl.define do
  factory :brand do
    name { FFaker::Product.brand }
    contact_name { FFaker::Name.name }
    contact_email { FFaker::Internet.email }
    contact_position { FFaker::Company.position }
    company
  end
end
