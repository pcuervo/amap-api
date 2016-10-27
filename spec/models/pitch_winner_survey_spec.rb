require 'rails_helper'

RSpec.describe PitchWinnerSurvey, :type => :model do
  before { @pitch_winner_survey = FactoryGirl.build(:pitch_winner_survey) }
  subject { @pitch_winner_survey }

  it { should respond_to(:was_contract_signed) }
  it { should respond_to(:contract_signature_date) }
  it { should respond_to(:was_project_activated) }
  it { should respond_to(:when_will_it_activate) }

  it { should validate_presence_of(:contract_signature_date) }
  it { should validate_presence_of(:when_will_it_activate) }

  it { should belong_to(:agency) }
  it { should belong_to(:pitch) }

end
