require 'rails_helper'

RSpec.describe Agency, :type => :model do
  before { @agency = FactoryGirl.build(:agency) }
  subject { @agency }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of( :name )}

  it { should be_valid }

  describe "#add_skills" do
    it "adds a skill with level to an agency" do
      agency = FactoryGirl.create :agency
      Skill.delete_all
      2.times{ FactoryGirl.create :skill }
      skills_arr = []
      Skill.all.limit(2).each do |s|
        skill_obj = {}
        skill_obj[:id] = s.id
        skill_obj[:level] = Random.rand(2)
        skills_arr.push( skill_obj )
      end
      agency.skills.delete_all
      agency.add_skills( skills_arr )
      expect( agency.agency_skills.count ).to eql 2
    end

    it "updates a skill with level to an agency" do
      agency = FactoryGirl.create :agency
      Skill.delete_all
      FactoryGirl.create :skill

      skills_arr = []
      skill_obj = {}
      skill_obj[:id] = Skill.first.id
      skill_obj[:level] = 1
      skills_arr.push( skill_obj )
      agency.add_skills( skills_arr )

      skills_arr = []
      skill_obj = {}
      skill_obj[:id] = Skill.first.id
      skill_obj[:level] = 2
      skills_arr.push( skill_obj )
      agency.add_skills( skills_arr )

      expect( agency.agency_skills.count ).to eql 1
      expect( agency.agency_skills.first.level ).to eql 2
    end
  end

  describe "#add_criteria" do
    it "relates Criteria to an agency" do
      agency = FactoryGirl.create :agency
      criterium = FactoryGirl.create :criterium
      another_criterium = FactoryGirl.create :criterium
      criterium_arr = [ criterium.id, another_criterium.id ]
      agency.add_criteria( criterium_arr )
      expect( agency.criteria.count ).to eql 2
    end
  end

  describe "#add_exclusivity" do
    it "relates Exclusitivy to an agency" do
      agency = FactoryGirl.create :agency
      exclusivity_arr = [ 'Coca-Cola', 'Pepsi' ]
      agency.add_exclusivity_brands( exclusivity_arr )
      expect( agency.exclusivities.count ).to eql 2
    end
  end

  describe "#remove_exclusivity" do
    it "relates Exclusitivy to an agency" do
      agency = FactoryGirl.create :agency
      exclusivity_arr = [ 'Coca-Cola', 'Pepsi' ]
      agency.add_exclusivity_brands( exclusivity_arr )
      brand_to_remove_ids = [ AgencyExclusivity.last.id ]
      agency.remove_exclusivity_brands( brand_to_remove_ids )
      expect( agency.exclusivities.count ).to eql 1
    end
  end

  describe "#search" do
    it "relates Criteria to an agency" do
      Agency.destroy_all
      agency = FactoryGirl.create :agency
      agency.name = 'Corben'
      agency.save
      company = FactoryGirl.create :company
      company.agencies << agency
      company.save
      
      agencies = Agency.search( 'cor', company.id )
      puts agencies.to_yaml
      expect( agencies.count ).to eql 1

    end
  end
  
end