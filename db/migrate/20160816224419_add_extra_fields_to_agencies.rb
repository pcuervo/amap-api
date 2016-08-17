class AddExtraFieldsToAgencies < ActiveRecord::Migration[5.0]
  def change
    add_column :agencies, :phone, :string, after: :name, default: '-'
    add_column :agencies, :contact_name, :string, after: :phone
    add_column :agencies, :contact_email, :string, after: :contact_name
    add_column :agencies, :address, :string, after: :contact_email
    add_column :agencies, :latitude, :decimal, after: :address
    add_column :agencies, :longitude, :decimal, after: :latitude
    add_column :agencies, :website_url, :string, after: :longitude
    add_column :agencies, :num_employees, :integer, after: :website_url
    add_column :agencies, :golden_pitch, :boolean, after: :num_employees, default: false
    add_column :agencies, :silver_pitch, :boolean, after: :golden_pitch, default: false
    add_column :agencies, :medium_risk_pitch, :boolean, after: :silver_pitch, default: false
    add_column :agencies, :high_risk_pitch, :boolean, after: :medium_risk_pitch, default: false
  end
end
