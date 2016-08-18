class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :contact_name, :contact_email, :address, :latitude, :longitude, :website_url, :num_employees, :golden_pitch, :silver_pitch, :high_risk_pitch, :medium_risk_pitch, :logo
end
