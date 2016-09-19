FactoryGirl.define do
  factory :pitch_evaluation do
    pitch
    evaluation_status false
    pitch_status 1
    are_objectives_clear false
    has_selection_criteria true
    time_to_present "2s"
    is_budget_known true
    number_of_agencies ">4"
    are_deliverables_clear false
    is_marketing_involved false
    time_to_know_decision "2s"
    deliver_copyright_for_pitching true
    number_of_rounds "2r"
    score 0
    activity_status 1
    was_won false
  end
end
