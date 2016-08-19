require 'rails_helper'

RSpec.describe SuccessCase, :type => :model do
  before { @success_case = FactoryGirl.build(:success_case) }
  subject { @success_case }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:url) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  it { should belong_to(:agency) }

  it { should be_valid }
end
