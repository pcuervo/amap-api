FactoryGirl.define do
  factory :user_token do
    users
    auth_token "MyString"
  end
end
