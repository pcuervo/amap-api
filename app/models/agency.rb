class Agency < ApplicationRecord
    extend ActiveModel::Naming

  has_and_belongs_to_many :users
  has_many :success_cases
  has_many :agency_skills
  has_many :skills, :through => :agency_skills
  has_many :exclusivities, foreign_key: "agency_id", class_name: "AgencyExclusivity"
  has_and_belongs_to_many :criteria, :through => :agencies_criteria

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "", :path => ":rails_root/storage/agency/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
  
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  validates :name, uniqueness: true
  validates :name, presence: true

  def add_skills skills_array
    self.agency_skills.delete_all
    skills_array.each do |skill|
      self.add_skill( skill[:id], skill[:level] )
    end
    self.save
  end

  def add_skill id, level
    agency_skill = AgencySkill.create(:agency_id => self.id, :skill_id => id, :level => level )
    self.agency_skills << agency_skill
  end

  def add_criteria criteria_array
    self.criteria.delete_all
    criteria_array.each do |criterium_id|
      self.add_criterium( criterium_id )
    end
    self.save
  end

  def add_criterium id
    criterium = Criterium.find(id)
    self.criteria << criterium
  end

  def add_exclusivity_brands brands_array
    brands_array.each do |brand|
      exclusivity = AgencyExclusivity.create( :brand => brand )
      self.exclusivities << exclusivity
    end
    self.save
  end

  def remove_exclusivity_brands brand_ids_array
    brand_ids_array.each do |id|
      exclusivity = AgencyExclusivity.find( id )
      exclusivity.destroy
    end
    self.save
  end

end
