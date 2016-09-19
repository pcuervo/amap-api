class AddSelectionCriteriaToPitchEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :pitch_evaluations, :has_selection_criteria, :boolean
  end
end
