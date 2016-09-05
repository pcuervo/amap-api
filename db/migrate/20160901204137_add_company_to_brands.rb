class AddCompanyToBrands < ActiveRecord::Migration[5.0]
  def change
    add_reference :brands, :company, foreign_key: true
  end
end
