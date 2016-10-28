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
      expect( evaluations.count ).to eq 2
      expect( evaluations.first ).to include(:pitch_types)
    end
  end

  describe "#filter" do
    it "gets all archived PitchEvaluations" do
      user = FactoryGirl.create :user
      agency = FactoryGirl.create :agency
      agency.users << user 
      agency.save
      3.times do |i|
        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        if 0 == i
          pitch_evaluation.pitch_status = PitchEvaluation::ARCHIVED
        end 
        pitch_evaluation.calculate_score
        pitch_evaluation.user = user 
        pitch_evaluation.save
      end
      
      params = {}
      params[:archived] = true
      params[:cancelled] = false
      params[:declined] = false
      params[:happitch] = false
      params[:happy] = false
      params[:ok] = false
      params[:unhappy] = false

      evaluations = PitchEvaluation.filter( user.id, params )
      expect( evaluations.count ).to eql 1
    end

    it "gets all archived and cancelled PitchEvaluations" do
      user = FactoryGirl.create :user
      agency = FactoryGirl.create :agency
      agency.users << user 
      agency.save
      3.times do |i|
        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        if 0 == i
          pitch_evaluation.pitch_status = PitchEvaluation::ARCHIVED
        end 
        if 1 == i
          pitch_evaluation.pitch_status = PitchEvaluation::CANCELLED
        end 
        pitch_evaluation.calculate_score
        pitch_evaluation.user = user 
        pitch_evaluation.save
      end
      
      params = {}
      params[:archived] = true
      params[:cancelled] = true
      params[:declined] = false
      params[:happitch] = false
      params[:happy] = false
      params[:ok] = false
      params[:unhappy] = false

      evaluations = PitchEvaluation.filter( user.id, params )
      expect( evaluations.count ).to eql 2
    end
  end

  describe "#average_per_month_by_user" do
    it "gets the average score of PitchEvaluations by user per month" do
      user = FactoryGirl.create :user
      agency = FactoryGirl.create :agency
      agency.users << user 
      agency.save
      3.times do |i|
        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        if 0 == i
          pitch_evaluation.pitch_status = PitchEvaluation::ARCHIVED
        end 
        pitch_evaluation.calculate_score
        pitch_evaluation.user = user 
        pitch_evaluation.save
      end
      
      pe = PitchEvaluation.average_per_month_by_user( user.id )
      puts pe.to_yaml

      evaluations = PitchEvaluation.filter( user.id, params )
      expect( evaluations.count ).to eql 1
    end

  end

  
end
