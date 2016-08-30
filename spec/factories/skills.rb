FactoryGirl.define do
  sequence(:random_skill) do |n|
    @random_skills ||= (1..10000).to_a.shuffle
    @random_skills[n]
  end

  factory :skill do
    name { FFaker::HipsterIpsum.word + ' ' + FactoryGirl.generate(:random_skill).to_s }
    skill_category
  end
end
