class CreateAgencySkills < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_skills do |t|
      t.references  :agency, foreign_key: true
      t.references  :skill,  foreign_key: true
      t.integer     :level

      t.timestamps
    end
  end
end
