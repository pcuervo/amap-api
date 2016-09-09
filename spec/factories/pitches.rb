FactoryGirl.define do
  factory :pitch do
    name "The pitch"
    skill_category
    brief_date Date.now
    brief_email_contact { FFaker::Internet.email }
  end
end
