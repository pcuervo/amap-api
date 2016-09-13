FactoryGirl.define do
  factory :pitch do
    name { FFaker::Product.product }
    brand
    brief_date Date.today
    brief_email_contact { FFaker::Internet.email }
  end
end
