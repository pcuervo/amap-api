require 'rails_helper'

RSpec.describe PitchEvaluation, :type => :model do
  before { @pitch_evaluation = FactoryGirl.build(:pitch_evaluation) }
  subject { @pitch_evaluation }

  describe "#calculate_score" do
    it "calculate the score of a PitchEvaluation" do
      pitch_evaluation = FactoryGirl.create :pitch_evaluation
      pitch_evaluation.calculate_score
      expect( pitch_evaluation.score ).to be > 0
    end
  end
end
