require 'rails_helper'

RSpec.describe Pitch, :type => :model do
  before { @pitch = FactoryGirl.build(:pitch) }
  subject { @pitch }

  it { should respond_to(:name) }
  it { should respond_to(:brief_date) }
  it { should respond_to(:brief_email_contact) }

  it { should belong_to(:skill_category) }
  it { should belong_to(:brand) }

  it { should be_valid }
end
