require 'rails_helper'

RSpec.describe Api::V1::PitchWinnerSurveysController, :type => :controller do
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user
        agency = FactoryGirl.create :agency 
        pitch = FactoryGirl.create :pitch

        @pitch_winner_survey_attributes = FactoryGirl.attributes_for :pitch_winner_survey
        @pitch_winner_survey_attributes[:agency_id] = agency.id 
        @pitch_winner_survey_attributes[:pitch_id] = pitch.id 

        puts @pitch_winner_survey_attributes.to_json

        post :create, params: { auth_token: @admin.auth_token, pitch_winner_survey: @pitch_winner_survey_attributes }, format: :json
      end

      it "renders the json representation for the agency record just created" do
        pws_response = json_response
        expect(pws_response[:was_contract_signed]).to eql @pitch_winner_survey_attributes[:was_contract_signed]
      end

      it { should respond_with 201 }
    end

    # context "when is not created because name is not present" do
    #   before(:each) do
    #     api_key = ApiKey.create
    #     api_authorization_header 'Token ' + api_key.access_token
    #     @admin = FactoryGirl.create :user

    #     @agency_attributes = FactoryGirl.attributes_for :agency
    #     @agency_attributes[:name] = ''
    #     post :create, params: { auth_token: @admin.auth_token, agency: @agency_attributes }, format: :json
    #   end

    #   it "renders an errors json" do
    #     pws_response = json_response
    #     expect(pws_response).to have_key(:errors)
    #   end

    #   it "renders the json errors when no agency name is present" do
    #     pws_response = json_response
    #     expect(pws_response[:errors][:name]).to include "El nombre de la agencia no puede estar vacío"
    #   end

    #   it { should respond_with 422 }
    # end

    # context "when is not created because name already exists" do
    #   before(:each) do
    #     api_key = ApiKey.create
    #     api_authorization_header 'Token ' + api_key.access_token
    #     @admin = FactoryGirl.create :user

    #     existing_agency = FactoryGirl.create :agency
    #     @agency_attributes = FactoryGirl.attributes_for :agency
    #     @agency_attributes[:name] = existing_agency.name
    #     post :create, params: { auth_token: @admin.auth_token, agency: @agency_attributes }, format: :json
    #   end

    #   it "renders an errors json" do
    #     pws_response = json_response
    #     expect(pws_response).to have_key(:errors)
    #   end

    #   it "renders the json errors saying an agency already exists with that name" do
    #     pws_response = json_response
    #     expect(pws_response[:errors][:name]).to include "Ya existe una agencia con ese nombre"
    #   end

    #   it { should respond_with 422 }
    # end

  end #POST create
end
