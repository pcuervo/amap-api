require 'rails_helper'

RSpec.describe Company, :type => :model do
  before { @company = FactoryGirl.build(:company) }
  subject { @company }

  it { should respond_to(:name) }

  it { should be_valid }
end
