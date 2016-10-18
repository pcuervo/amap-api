FactoryGirl.define do
  factory :pitch_result do
    agency
    pitch
    was_proposal_presented false
    got_response false
    was_pitch_won false
    got_feedback false
    has_someone_else_won false
    when_will_you_get_response "2016-10-17"
    when_are_you_presenting "2016-10-17"
  end
end
