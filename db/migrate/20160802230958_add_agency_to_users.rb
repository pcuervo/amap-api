class AddAgencyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :agency, index: true, after: :email
    add_foreign_key :users, :agencies
  end
end
