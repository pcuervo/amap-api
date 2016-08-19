class AddAttachmentCaseImageToSuccessCases < ActiveRecord::Migration
  def self.up
    change_table :success_cases do |t|
      t.attachment :case_image
    end
  end

  def self.down
    remove_attachment :success_cases, :case_image
  end
end
