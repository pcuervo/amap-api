require 'rails_helper'

RSpec.describe Pitch, :type => :model do
  before { @pitch = FactoryGirl.build(:pitch) }
  subject { @pitch }

  it { should respond_to(:name) }
  it { should respond_to(:brief_date) }
  it { should respond_to(:brief_email_contact) }

  it { should belong_to(:brand) }

  it { should be_valid }

  describe "#get_scores_except" do
    it "returns an array with all the scores from PitchEvaluation except the given one" do
      pitch = FactoryGirl.create :pitch
      pitch_evaluation_1 = FactoryGirl.create :pitch_evaluation
      pitch_evaluation_2 = FactoryGirl.create :pitch_evaluation
      pitch.pitch_evaluations << pitch_evaluation_1
      pitch.pitch_evaluations << pitch_evaluation_2
      pitch.save
      pitch_evaluation_1.calculate_score
      pitch_evaluation_2.calculate_score
      score_2 = pitch_evaluation_2.score

      scores = pitch.get_scores_except( pitch_evaluation_1.id )
      expect( scores.first ).to eq score_2
    end
  end
end
