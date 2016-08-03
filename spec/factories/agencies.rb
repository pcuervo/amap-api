FactoryGirl.define do
  factory :agency do
    name { FFaker::CompanyIT.name + Time.now.to_s }
  end
end
