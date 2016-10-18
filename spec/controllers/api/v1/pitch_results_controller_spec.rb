require 'rails_helper'

RSpec.describe Api::V1::PitchResultsController, :type => :controller do
  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @pitch_result = FactoryGirl.create :pitch_result
      get :show, params: { id: @pitch_result.id }, format: :json
    end

    it "returns the information about a Pitch on a hash" do
      expect(json_response[:was_proposal_presented]).to eql @pitch_result.was_proposal_presented
    end

    it "returns the Agency of the PitchResult" do 
      pitch_result_response = json_response
      expect(pitch_result_response).to have_key(:agency)
    end

    it { should respond_with 200 }
  end
end
