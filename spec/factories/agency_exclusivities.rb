FactoryGirl.define do
  factory :agency_exclusivity do
    agency
    brand { FFaker::Product.brand }
  end
end
