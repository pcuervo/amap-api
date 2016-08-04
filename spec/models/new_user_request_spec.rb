require 'rails_helper'

RSpec.describe NewUserRequest, :type => :model do
  before { @new_user_request = FactoryGirl.build(:new_user_request) }

  subject { @new_user_request }

  it { should respond_to(:email) }
  it { should respond_to(:agency) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should allow_value('example@domain.com').for(:email) }
end
