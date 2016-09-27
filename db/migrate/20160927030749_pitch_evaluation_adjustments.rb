class PitchEvaluationAdjustments < ActiveRecord::Migration[5.0]
  def change
    remove_column :pitch_evaluations, :is_marketing_involved
    remove_column :pitch_evaluations, :deliver_copyright_for_pitching
    add_column :pitch_evaluations, :is_marketing_involved, :string
    add_column :pitch_evaluations, :deliver_copyright_for_pitching, :string
  end
end
