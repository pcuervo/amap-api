class SuccessCase < ApplicationRecord
  belongs_to :agency

  has_attached_file :case_image, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "/images/:style/missing.png", :path => ":rails_root/storage/success_case/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"

  validates :name, :description, presence: true
  validates_attachment_content_type :case_image, content_type: /\Aimage\/.*\Z/

end