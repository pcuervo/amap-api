require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  describe "POST #create" do

    before(:each) do
      @user = FactoryGirl.create :user
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
    end

    context "when the credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: "holama123" }
        post :create, { user_session: credentials }, format: :json
      end

      it "returns the user record corresponding to the given credentials" do
        expect(json_response[:auth_token]).not_to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, { user_session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Email o password incorrecto"
      end

      it { should respond_with 422 }
    end
  end

end
