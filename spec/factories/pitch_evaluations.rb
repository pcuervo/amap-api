FactoryGirl.define do
  factory :pitch_evaluation do
    pitch
    evaluation_status false
    pitch_status 1
    are_objectives_clear false
    days_to_present "0"
    is_budget_known false
    number_of_agencies "0"
    are_deliverables_clear false
    is_marketing_involved false
    days_to_know_decision "0"
    deliver_copyright_for_pitching "0"
    know_presentation_rounds "0"
    number_of_rounds 1
    score 1
    activity_status 1
    was_won false
  end
end
