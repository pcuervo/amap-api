class CreateAgencyExclusivities < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_exclusivities do |t|
      t.references :agency, foreign_key: true
      t.string :brand

      t.timestamps
    end
  end
end
