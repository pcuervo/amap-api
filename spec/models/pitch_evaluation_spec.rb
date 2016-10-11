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
    it "returns all PitchEvaluations for agency regular user" do
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

    it "returns all PitchEvaluations for agency admin user" do
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

    it "returns all PitchEvaluations for client admin user" do
      agency = FactoryGirl.create :agency
      pitch = @pitch_evaluation.pitch
      another_pitch_evaluation = FactoryGirl.create :pitch_evaluation
      another_pitch_evaluation.calculate_score
      pitch.pitch_evaluations << another_pitch_evaluation
      pitch.pitch_evaluations << @pitch_evaluation

      client_user = FactoryGirl.create :user
      client_user.role = User::CLIENT_USER
      client_user.save
      pitch.brief_email_contact = client_user.email
      pitch.users << client_user
      pitch.save

      evaluations = PitchEvaluation.pitches_by_user client_user.id
      expect( evaluations.count ).to eq 1
      expect( evaluations.first ).to include(:pitch_types)
    end

    it "returns all PitchEvaluations for client admin user" do
      agency = FactoryGirl.create :agency
      brand = FactoryGirl.create :brand
      company = brand.company
      pitch = @pitch_evaluation.pitch
      pitch.brand = brand
      puts brand.id.to_yaml

      another_pitch = FactoryGirl.create :pitch
      another_pitch.brand = brand
      another_pitch_evaluation = FactoryGirl.create :pitch_evaluation
      another_pitch_evaluation.calculate_score
      pitch.pitch_evaluations << another_pitch_evaluation
      another_pitch.pitch_evaluations << @pitch_evaluation
      another_pitch.save

      admin_client = FactoryGirl.create :user
      admin_client.role = User::CLIENT_ADMIN
      admin_client.companies << company
      admin_client.save
      pitch.save

      evaluations = PitchEvaluation.pitches_by_user admin_client.id
      puts evaluations.first.to_yaml
      expect( evaluations.count ).to eq 2
      expect( evaluations.first ).to include(:pitch_types)
    end
  end

  
end
