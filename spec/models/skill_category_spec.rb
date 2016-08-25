require 'rails_helper'

RSpec.describe SkillCategory, :type => :model do
  before { @skill_category = FactoryGirl.build(:skill_category) }
  subject { @skill_category }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of( :name )}

  it { should have_many(:skills) }

  it { should be_valid }
end
