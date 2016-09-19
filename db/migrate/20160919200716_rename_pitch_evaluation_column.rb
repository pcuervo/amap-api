class RenamePitchEvaluationColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :pitch_evaluations, :days_to_present, :time_to_present
  end
end
