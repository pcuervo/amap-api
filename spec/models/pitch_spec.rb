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

  describe "#merge" do
    it "returns an array with all the scores from PitchEvaluation except the given one" do
      pitch = FactoryGirl.create :pitch
      bad_pitch = FactoryGirl.create :pitch
      pitch_evaluation_1 = FactoryGirl.create :pitch_evaluation
      pitch_evaluation_2 = FactoryGirl.create :pitch_evaluation
      pitch.pitch_evaluations << pitch_evaluation_1
      bad_pitch.pitch_evaluations << pitch_evaluation_2
      pitch.save
      bad_pitch.save

      expect( pitch.merge( bad_pitch ) ).to eq true
      expect( pitch.pitch_evaluations.count ).to eq 2
    end
  end

  describe "#get_winner" do
    it "returns the name of Agency who won the pitch" do
      agency = FactoryGirl.create :agency
      pitch = FactoryGirl.create :pitch
      pitch_evaluation_1 = FactoryGirl.create :pitch_evaluation
      pitch.pitch_evaluations << pitch_evaluation_1
      winner_survey = FactoryGirl.create :pitch_winner_survey
      winner_survey.agency = agency
      winner_survey.pitch = pitch 
      winner_survey.save
      pitch.save

      expect( pitch.get_winner ).to eq agency.name
    end

    it "returns 0 if no one has one the Pitch" do
      pitch = FactoryGirl.create :pitch
      pitch_evaluation_1 = FactoryGirl.create :pitch_evaluation
      pitch.pitch_evaluations << pitch_evaluation_1
      pitch.save

      expect( pitch.get_winner ).to eq 0
    end
  end

  describe "#get_evaluation_breakdown" do
    it "returns the name of Agency who won the pitch" do
      pitch = FactoryGirl.create :pitch
      pitch_evaluation = FactoryGirl.create :pitch_evaluation
      pitch_evaluation2 = FactoryGirl.create :pitch_evaluation
      pitch_evaluation.are_objectives_clear = true
      pitch_evaluation.calculate_score
      pitch_evaluation2.calculate_score
      pitch_evaluation.save
      pitch_evaluation2.save
      pitch.pitch_evaluations << pitch_evaluation
      pitch.pitch_evaluations << pitch_evaluation2
      pitch.save

      breakdown = pitch.get_evaluation_breakdown
      expect( breakdown['objectives_clear'] ).to eq 50
    end
  end
end
