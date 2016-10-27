class CreatePitchWinnerSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :pitch_winner_surveys do |t|
      t.references :agency, foreign_key: true
      t.references :pitch, foreign_key: true
      t.boolean :was_contract_signed
      t.date :contract_signature_date
      t.boolean :was_project_activated
      t.date :when_will_it_activate

      t.timestamps
    end
  end
end
