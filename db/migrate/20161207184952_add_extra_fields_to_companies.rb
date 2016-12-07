class AddExtraFieldsToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :contact_name, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :contact_position, :string
  end
end
