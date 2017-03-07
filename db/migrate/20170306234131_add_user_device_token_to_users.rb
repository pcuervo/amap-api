class AddUserDeviceTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :device_token, :string, after: :is_member_amap, default: ''
  end
end
