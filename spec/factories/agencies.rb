FactoryGirl.define do
  factory :agency do
    name { FFaker::Name.name + rand(1000).to_s }
    phone { FFaker::PhoneNumberMX.home_work_phone_number }
    contact_name { FFaker::Name.name }
    contact_email { FFaker::Internet.email }
    address { FFaker::Address.street_name + ', ' + FFaker::Address.city }
    latitude 19.401710
    longitude -99.170933
    website_url { FFaker::Internet.http_url }
    num_employees 8
  end
end
