class Agency < ApplicationRecord
  has_many :users

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "/images/:style/missing.png", :path => ":rails_root/storage/agency/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
  
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  validates :name, uniqueness: true
  validates :name, presence: true
end
