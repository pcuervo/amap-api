class CreateJoinTableAgencyUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :agencies, :users do |t|
      # t.index [:agency_id, :user_id]
      # t.index [:user_id, :agency_id]
    end
  end
end
