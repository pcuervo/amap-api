require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do
  # This should return the minimal set of attributes required to create a valid
  # Agency. As you add validations to Agency, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
    FactoryGirl.attributes_for :user
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, { id: @user.id }, format: :json
    end

    it "returns the information about a user on a hash" do
      expect(json_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        @user = FactoryGirl.create :user
        @agency = FactoryGirl.create :agency
        @user_attributes[:agency_id] = @agency.id
        api_authorization_header @user.auth_token
        post :create, { id: @user.id, user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
        expect(user_response[:is_member_amap]).to eql @user_attributes[:is_member_amap]
      end

      it "is part of an agency" do
        user_response = json_response
        expect(user_response[:agency][:id]).to eql @agency.id
      end

      it { should respond_with 201 }
    end

    context "when is not created because agency is not present" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        @user_attributes[:agency_id] = -1
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        post :create, { id: @user.id, user: @user_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors when no agency is present" do
        user_response = json_response
        expect(user_response[:errors][:agency]).to include "La agencia es obligatoria"
      end

      it { should respond_with 422 }
    end
  end # POST create

  describe "POST #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        @new_email = FFaker::Internet.email
        api_authorization_header @user.auth_token
        patch :update, { id: @user.id,
                         user: { email: @new_email, first_name: 'Juan' } }, format: :json
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql @new_email
        expect(user_response[:first_name]).to eql 'Juan'
      end

      it { should respond_with 200 }
    end

    # context "when is not updated" do
    #   before(:each) do
    #     @user = FactoryGirl.create :user
    #     api_authorization_header @user.auth_token
    #     patch :update, { id: @user.id,
    #                      user: { email: "bademail.com", role: 5 } }, format: :json
    #   end

    #   it "renders an errors json" do
    #     user_response = json_response
    #     expect(user_response).to have_key(:errors)
    #   end

    #   it "renders the json errors when the email is invalid" do
    #     user_response = json_response
    #     expect(user_response[:errors][:email]).to include "is invalid"
    #   end

    #   it { should respond_with 422 }
    # end
  end # POST update

end
