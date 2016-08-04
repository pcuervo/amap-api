class CreateNewUserRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :new_user_requests do |t|
      t.string  :email, null: false
      t.string  :agency, null: false, default: ''
      t.string  :user_type, null: false, default: 'agencia'
      t.timestamps
    end
  end
end
