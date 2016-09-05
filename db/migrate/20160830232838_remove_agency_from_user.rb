class RemoveAgencyFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :agency_id
  end
end
