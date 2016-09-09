class CreatePitches < ActiveRecord::Migration[5.0]
  def change
    create_table :pitches do |t|
      t.string :name
      t.references :skill_category, foreign_key: true
      t.date :brief_date
      t.string :brief_email_contact

      t.timestamps
    end
  end
end

