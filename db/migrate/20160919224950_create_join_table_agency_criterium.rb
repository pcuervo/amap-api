class CreateJoinTableAgencyCriterium < ActiveRecord::Migration[5.0]
  def change
    create_join_table :agencies, :criteria do |t|
      # t.index [:agency_id, :criterium_id]
      # t.index [:criterium_id, :agency_id]
    end
  end
end
