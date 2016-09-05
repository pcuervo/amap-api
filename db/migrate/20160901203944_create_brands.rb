class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_position

      t.timestamps
    end
  end
end
