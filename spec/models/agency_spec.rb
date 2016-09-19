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

    # it "updates a skill with level to an agency" do
    #   agency = FactoryGirl.create :agency
    #   Skill.delete_all
    #   FactoryGirl.create :skill

    #   skills_arr = []
    #   skill_obj = {}
    #   skill_obj[:id] = Skill.first.id
    #   skill_obj[:level] = 1
    #   skills_arr.push( skill_obj )
    #   agency.add_skills( skills_arr )

    #   skills_arr = []
    #   skill_obj = {}
    #   skill_obj[:id] = Skill.first.id
    #   skill_obj[:level] = 2
    #   skills_arr.push( skill_obj )
    #   agency.add_skills( skills_arr )

    #   expect( agency.agency_skills.count ).to eql 1
    #   expect( agency.agency_skills.first.level ).to eql 2
    # end
  end
  
end