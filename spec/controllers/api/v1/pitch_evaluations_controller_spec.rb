require 'rails_helper'

RSpec.describe Api::V1::PitchEvaluationsController, :type => :controller do
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch = Pitch.last
        @pitch_evaluation_attributes = FactoryGirl.attributes_for :pitch_evaluation
        @pitch_evaluation_attributes[:pitch_id] = @pitch.id
        post :create, params: { auth_token: @admin.auth_token, pitch_evaluation: @pitch_evaluation_attributes }, format: :json
      end

      it "renders the json representation for the PitchEvaluation record just created" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[:name]).to eql @pitch_evaluation_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because pitch is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch_evaluation_attributes = FactoryGirl.attributes_for :pitch_evaluation
        post :create, params: { auth_token: @admin.auth_token, pitch_evaluation: @pitch_evaluation_attributes }, format: :json
      end

      it "renders an errors json" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response).to have_key(:errors)
      end

      it "renders the json errors when no Pitch is present" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[:errors][:pitch]).to include "El pitch es obligatorio"
      end

      it { should respond_with 422 }
    end

    context "when is not created because a PitchEvaluation already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user
        agency = FactoryGirl.create :agency
        agency.users << @admin
        agency.save
    
        @pitch = Pitch.last
        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        pitch_evaluation.pitch = @pitch
        pitch_evaluation.user = @admin
        pitch_evaluation.save
        @pitch.save

        @pitch_evaluation_attributes = FactoryGirl.attributes_for :pitch_evaluation
        @pitch_evaluation_attributes[:pitch_id] = @pitch.id
        post :create, params: { auth_token: @admin.auth_token, pitch_evaluation: @pitch_evaluation_attributes }, format: :json
      end

      it "renders an errors json" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end #POST create

  describe "POST #update" do
    context "when is successfully updated" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch = Pitch.last
        @pitch_evaluation = FactoryGirl.create :pitch_evaluation
        post :update, params: { auth_token: @admin.auth_token, id: @pitch_evaluation.id,
                        pitch_evaluation: { pitch_id: @pitch.id } }, format: :json
      end

      it "renders the json representation for the pitch_evaluation record just updated" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[:pitch_id]).to eql @pitch.id
      end

      it { should respond_with 200 }
    end

  end #POST update

  describe "POST #by_user" do
    context "when is successfully fetched" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user
        agency = FactoryGirl.create :agency
        agency.users << @admin
        agency.save

        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        @pitch = pitch_evaluation.pitch
        another_pitch_evaluation = FactoryGirl.create :pitch_evaluation
        another_pitch_evaluation.calculate_score
        @pitch.pitch_evaluations << another_pitch_evaluation
        @pitch.save
        pitch_evaluation.user_id = @admin.id
        pitch_evaluation.calculate_score
        pitch_evaluation.save

        post :by_user, params: { auth_token: @admin.auth_token }, format: :json
      end

      it "returns all the pitches that belong to a user" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[0][:pitch_id]).to eql @pitch.id
      end

      it { should respond_with 200 }
    end

  end #POST by_user

  describe "POST #cancel" do
    context "when is successfully fetched" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user
        agency = FactoryGirl.create :agency
        agency.users << @admin
        agency.save

        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        pitch_evaluation.pitch_status = PitchEvaluation::ACTIVE
        pitch_evaluation.user_id = @admin.id
        pitch_evaluation.save

        post :cancel, params: { auth_token: @admin.auth_token, id: pitch_evaluation.id }, format: :json
      end

      it "returns the cancelled pitch" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[:pitch_status]).to eql PitchEvaluation::CANCELLED
      end

      it { should respond_with 200 }
    end
  end #POST cancel

  describe "POST #decline" do
    context "when is successfully fetched" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user
        agency = FactoryGirl.create :agency
        agency.users << @admin
        agency.save

        pitch_evaluation = FactoryGirl.create :pitch_evaluation
        pitch_evaluation.pitch_status = PitchEvaluation::ACTIVE
        pitch_evaluation.user_id = @admin.id
        pitch_evaluation.save

        post :decline, params: { auth_token: @admin.auth_token, id: pitch_evaluation.id }, format: :json
      end

      it "returns the declined pitch" do
        pitch_evaluation_response = json_response
        expect(pitch_evaluation_response[:pitch_status]).to eql PitchEvaluation::DECLINED
      end

      it { should respond_with 200 }
    end
  end

end
