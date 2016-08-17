class AddAttachmentLogoToAgencies < ActiveRecord::Migration
  def self.up
    change_table :agencies do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :agencies, :logo
  end
end
