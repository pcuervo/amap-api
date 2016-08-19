class AddAgencyToSuccessCases < ActiveRecord::Migration[5.0]
  def change
    add_reference :success_cases, :agency, index: true, after: :url
    add_foreign_key :success_cases, :agencies
  end
end
