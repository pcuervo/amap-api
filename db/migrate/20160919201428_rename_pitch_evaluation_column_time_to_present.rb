class RenamePitchEvaluationColumnTimeToPresent < ActiveRecord::Migration[5.0]
  def change
    rename_column :pitch_evaluations, :days_to_know_decision, :time_to_know_decision
  end
end
