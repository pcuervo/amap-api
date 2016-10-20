require 'rails_helper'

RSpec.describe Api::V1::PitchResultsController, :type => :controller do

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        agency = FactoryGirl.create :agency
        pitch = FactoryGirl.create :pitch
        @pitch_result_attributes = FactoryGirl.attributes_for :pitch_result
        @pitch_result_attributes[:agency_id] = agency.id
        @pitch_result_attributes[:pitch_id] = pitch.id
        post :create, params: { auth_token: @admin.auth_token, pitch_result: @pitch_result_attributes }, format: :json
      end

      it "renders the json representation for the PitchResult just created" do
        pitch_result_response = json_response
        expect(pitch_result_response[:agency_id]).to eql @pitch_result_attributes[:agency_id]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch_result_attributes = FactoryGirl.attributes_for :pitch_result
        puts @pitch_result_attributes.to_json
        post :create, params: { auth_token: @admin.auth_token, pitch_result: @pitch_result_attributes }, format: :json
      end

      it "includes an errors key" do
        pitch_result_response = json_response
        expect(pitch_result_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end #POST create

end
