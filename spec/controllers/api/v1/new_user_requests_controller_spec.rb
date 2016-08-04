require 'rails_helper'

RSpec.describe Api::V1::NewUserRequestsController, :type => :controller do
  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @new_user_request_attributes = FactoryGirl.attributes_for :new_user_request
        @user = FactoryGirl.create :user
        @agency = FactoryGirl.create :agency
        api_authorization_header @user.auth_token
        post :create, { id: @user.id, new_user_request: @new_user_request_attributes }, format: :json
      end

      it "renders the json representation for the new_user_request record just created" do
        puts json_response.to_yaml
        new_user_request_response = json_response
        expect(new_user_request_response[:email]).to eql @new_user_request_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created because email is not present" do
      before(:each) do
        @new_user_request = FactoryGirl.create :new_user_request
        @invalid_user_attributes = { agency: 'Flock' }
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        post :create, { id: @user.id, new_user_request: @invalid_user_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors when no agency is present" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "El email no puede estar vacío"
      end

      it { should respond_with 422 }
    end
  end # POST create
end
