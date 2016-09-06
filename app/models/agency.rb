class Agency < ApplicationRecord
    extend ActiveModel::Naming

  has_and_belongs_to_many :users
  has_many :success_cases
  has_many :agency_skills
  has_many :skills, :through => :agency_skills

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "/images/:style/missing.png", :path => ":rails_root/storage/agency/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
  
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  validates :name, uniqueness: true
  validates :name, presence: true

  def add_skills skills_array
    skills_array.each do |skill|
      self.add_skill( skill[:id], skill[:level] )
    end
    self.save
  end

  def add_skill id, level

    existing_skill = self.agency_skills.where('skill_id = ?', id).first
    if existing_skill.present? 
      existing_skill.level = level
      existing_skill.save!
      return
    end
    agency_skill = AgencySkill.create(:agency_id => self.id, :skill_id => id, :level => level )
    self.agency_skills << agency_skill
  end

end
