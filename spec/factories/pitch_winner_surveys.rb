FactoryGirl.define do
  factory :pitch_winner_survey do
    agency
    pitch
    was_contract_signed true
    contract_signature_date "2016-10-27"
    was_project_activated false
    when_will_it_activate "2016-10-27"
  end
end
