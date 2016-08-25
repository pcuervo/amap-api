FactoryGirl.define do
  factory :skill do
    name { FFaker::HipsterIpsum.word + ' ' + Random.rand(100).to_s }
    skill_category
  end
end
