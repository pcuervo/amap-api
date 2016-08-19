FactoryGirl.define do
  factory :success_case do
    name { FFaker::Company.name }
    description { FFaker::HipsterIpsum.paragraph }
    url "http://theagency.io"
    agency
  end
end
