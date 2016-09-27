require 'rails_helper'

RSpec.describe AgencyExclusivity, :type => :model do
  before { @agency_exclusivity = FactoryGirl.build(:agency_exclusivity) }
  subject { @agency_exclusivity }

  it { should respond_to(:brand) }
  it { should belong_to(:agency) }
end
