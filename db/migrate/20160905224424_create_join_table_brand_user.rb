class CreateJoinTableBrandUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :brands, :users do |t|
      # t.index [:brand_id, :user_id]
      # t.index [:user_id, :brand_id]
    end
  end
end
