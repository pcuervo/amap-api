class CreateCompanyConflictBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :company_conflict_brands do |t|
      t.references :company, foreign_key: true
      t.string :brand

      t.timestamps
    end
  end
end
