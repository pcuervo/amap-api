class ChangeAgencyNewUserRequest < ActiveRecord::Migration[5.0]
  def change
    rename_column :new_user_requests, :agency, :agency_brand
  end
end
