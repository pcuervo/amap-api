class AddExtraFieldsPitchEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :pitch_evaluations, :number_of_rounds, :string
    add_column :pitch_evaluations, :deliver_copyright_for_pitching, :boolean
  end
end

