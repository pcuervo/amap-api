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

end
