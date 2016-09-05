require 'rails_helper'

RSpec.describe Brand, :type => :model do
  before { @brand = FactoryGirl.build(:brand) }
  subject { @brand }

  it { should respond_to(:name) }

  it { should belong_to(:company) }

  it { should be_valid }
end
