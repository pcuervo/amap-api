require 'rails_helper'

RSpec.describe Skill, :type => :model do
  before { @skill = FactoryGirl.build(:skill) }
  subject { @skill }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of( :name )}

  it { should belong_to(:skill_category) }

  it { should be_valid }
end
