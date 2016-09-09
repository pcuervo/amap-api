class CreatePitchEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :pitch_evaluations do |t|
      t.references :pitch,                      foreign_key: true
      t.references :user,                       foreign_key: true
      t.boolean :evaluation_status,             default: false
      t.integer :pitch_status,                  default: 0
      t.boolean :are_objectives_clear,          default: false
      t.string :days_to_present,                default: '0'
      t.boolean :is_budget_known,               default: false
      t.string :number_of_agencies,             default: '0'
      t.boolean :are_deliverables_clear,        default: false
      t.boolean :is_marketing_involved,         default: false
      t.string :days_to_know_decision,          default: '0'
      t.string :deliver_copyright_for_pitching, default: 'no'
      t.string :know_presentation_rounds,       default: '0'
      t.integer :number_of_rounds,              default: 0
      t.integer :score,                         default: 0
      t.integer :activity_status,               default: '-'
      t.boolean :was_won,                       default: false

      t.timestamps
    end
  end
end
