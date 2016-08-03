class AddIsMemberAmapToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_member_amap, :boolean, after: :email, default: 0
  end
end
