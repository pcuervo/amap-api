class RemoveSkillCategoryIdFromPitches < ActiveRecord::Migration[5.0]
  def change
    remove_column :pitches, :skill_category_id
  end
end
