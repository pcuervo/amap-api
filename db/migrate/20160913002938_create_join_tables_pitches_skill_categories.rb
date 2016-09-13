class CreateJoinTablesPitchesSkillCategories < ActiveRecord::Migration[5.0]
  def change
    create_join_table :pitches, :skill_categories do |t|
      # t.index [:pitch_id, :skill_category_id]
      # t.index [:skill_category_id, :pitch_id]
    end
  end
end
