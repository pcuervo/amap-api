FactoryGirl.define do
  factory :user do
    email                 { FFaker::Internet.email }
    first_name            'Miguel'
    last_name             'Cabral'
    password              'holama123'
    password_confirmation 'holama123' 
    is_member_amap        false
    agency
  end
end
