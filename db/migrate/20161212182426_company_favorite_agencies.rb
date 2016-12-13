class CompanyFavoriteAgencies < ActiveRecord::Migration[5.0]
  def change
    create_join_table :agencies, :companies, { :table_name => 'favorite_agencies' } do |t|
      # t.index [:company_id, :agency_id]
      # t.index [:agency_id, :company_id]
    end
  end
end
