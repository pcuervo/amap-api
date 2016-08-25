FactoryGirl.define do
  factory :skill_category do
    name { FFaker::HipsterIpsum.word + ' ' + Random.rand(100).to_s }
  end
end
