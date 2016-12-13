class Company < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :brands
  has_many :favorite_agencies

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "", :path => ":rails_root/storage/agency/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
  
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true

end
