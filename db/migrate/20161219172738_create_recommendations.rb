class CreateRecommendations < ActiveRecord::Migration[5.0]
  def change
    create_table :recommendations do |t|
      t.string :body
      t.string :reco_id
      t.string :reco_type, default: 'agency'
      t.timestamps
    end
  end
end
