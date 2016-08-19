require 'rails_helper'

RSpec.describe Agency, :type => :model do
  before { @agency = FactoryGirl.build(:agency) }
  subject { @agency }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of( :name )}

  it { should have_many(:users) }

  it { should be_valid }
  
end