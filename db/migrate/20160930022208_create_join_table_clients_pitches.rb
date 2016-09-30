class CreateJoinTableClientsPitches < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :pitches do |t|
      # t.index [:user_id, :pitch_id]
      # t.index [:pitch_id, :user_id]
    end
  end
end
