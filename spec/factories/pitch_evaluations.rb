FactoryGirl.define do
  factory :pitch_evaluation do
    pitch nil
    evaluation_status false
    pitch_status 1
    are_objectives_clear false
    days_to_present "MyString"
    is_budget_known false
    number_of_agencies "MyString"
    are_deliverables_clear false
    is_marketing_involved false
    days_to_know_decision "MyString"
    deliver_copyright_for_pitching "MyString"
    know_presentation_rounds "MyString"
    number_of_rounds 1
    score 1
    activity_status 1
    was_won false
  end
end
