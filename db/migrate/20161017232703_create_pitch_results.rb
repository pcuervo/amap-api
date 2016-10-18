class CreatePitchResults < ActiveRecord::Migration[5.0]
  def change
    create_table :pitch_results do |t|
      t.references :agency, foreign_key: true
      t.references :pitch, foreign_key: true
      t.boolean :was_proposal_presented, default: false
      t.boolean :got_response, default: true
      t.boolean :was_pitch_won, default: true
      t.boolean :got_feedback, default: true
      t.boolean :has_someone_else_won, default: true
      t.date :when_will_you_get_response
      t.date :when_are_you_presenting

      t.timestamps
    end
  end
end
