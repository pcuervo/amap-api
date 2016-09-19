class RemoveExtraFielsPitchEvaluations < ActiveRecord::Migration[5.0]
  def change
    remove_column :pitch_evaluations, :know_presentation_rounds
    remove_column :pitch_evaluations, :number_of_rounds
    remove_column :pitch_evaluations, :deliver_copyright_for_pitching
  end
end
