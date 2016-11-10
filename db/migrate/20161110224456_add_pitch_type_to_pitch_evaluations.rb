class AddPitchTypeToPitchEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :pitch_evaluations, :pitch_type, :string
  end
end
