require 'rails_helper'

RSpec.describe AgencySkill, :type => :model do
  before { @agency_skill = FactoryGirl.build(:agency_skill) }
  subject { @agency_skill }

  it { should respond_to(:level) }

  it { should belong_to(:agency) }
  it { should belong_to(:skill) }

  it { should be_valid }
end
