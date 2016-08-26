require 'rails_helper'

RSpec.describe Agency, :type => :model do
  before { @agency = FactoryGirl.build(:agency) }
  subject { @agency }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of( :name )}

  it { should have_many(:users) }

  it { should be_valid }

  describe "#add_skills" do
    it "adds a skill with level to an agency" do
      agency = FactoryGirl.create :agency
      5.times{ FactoryGirl.create :skill }
      skills_arr = []
      Skill.all.limit(5).each do |s|
        skill_obj = {}
        skill_obj[:id] = s.id
        skill_obj[:level] = Random.rand(5)
        skills_arr.push( skill_obj )
      end
      agency.skills.delete_all
      agency.add_skills( skills_arr )
      expect( agency.agency_skills.count ).to eql 5
    end

  end
  
end