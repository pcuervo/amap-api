class AddBrandToPitches < ActiveRecord::Migration[5.0]
  def change
    add_reference :pitches, :brand, foreign_key: true
  end
end
