class AddExtraFieldsToAgencies < ActiveRecord::Migration[5.0]
  def change
    add_column :agencies, :phone, :string, before: :created_at, default: '-'
    add_column :agencies, :contact_name, :string, before: :created_at
    add_column :agencies, :contact_email, :string, before: :created_at
    add_column :agencies, :address, :string, before: :created_at
    add_column :agencies, :latitude, :decimal, before: :created_at
    add_column :agencies, :longitude, :decimal, before: :created_at
    add_column :agencies, :website_url, :string, before: :created_at
    add_column :agencies, :num_employees, :integer, before: :created_at
    add_column :agencies, :golden_pitch, :boolean, before: :created_at, default: false
    add_column :agencies, :silver_pitch, :boolean, before: :created_at, default: false
    add_column :agencies, :medium_risk_pitch, :boolean, before: :created_at, default: false
    add_column :agencies, :high_risk_pitch, :boolean, before: :created_at, default: false
  end
end
