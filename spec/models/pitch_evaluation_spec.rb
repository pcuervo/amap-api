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

  describe "#pitches_by_user" do
    it "returns all PitchEvaluations for regular user" do
      pitch = @pitch_evaluation.pitch
      another_pitch_evaluation = FactoryGirl.create :pitch_evaluation
      another_pitch_evaluation.calculate_score
      pitch.pitch_evaluations << another_pitch_evaluation
      pitch.save
      agency_user = FactoryGirl.create :user
      agency_user.role = User::AGENCY_USER
      agency_user.save
      @pitch_evaluation.user_id = agency_user.id
      @pitch_evaluation.calculate_score
      @pitch_evaluation.save

      pitches = PitchEvaluation.pitches_by_user agency_user.id
      expect( pitches.count ).to eq 1
      expect( pitches.first ).to include(:other_scores)
    end

    it "returns all PitchEvaluations for regular user" do
      agency = FactoryGirl.create :agency
      pitch = @pitch_evaluation.pitch
      another_pitch_evaluation = FactoryGirl.create :pitch_evaluation
      another_pitch_evaluation.calculate_score
      pitch.pitch_evaluations << another_pitch_evaluation
      pitch.save
      agency_user = FactoryGirl.create :user
      admin = FactoryGirl.create :user
      agency.users << agency_user
      agency.users << admin
      agency.save
      @pitch_evaluation.user_id = admin.id
      another_pitch_evaluation.user_id = agency_user.id
      another_pitch_evaluation.save
      @pitch_evaluation.calculate_score
      @pitch_evaluation.save

      pitches = PitchEvaluation.pitches_by_user admin.id
      expect( pitches.count ).to eq 2
      expect( pitches.first ).to include(:other_scores)
    end
  end
end
