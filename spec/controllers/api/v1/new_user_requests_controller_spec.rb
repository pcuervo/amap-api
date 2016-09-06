require 'rails_helper'

RSpec.describe Api::V1::NewUserRequestsController, :type => :controller do
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @new_user_request_attributes = FactoryGirl.attributes_for :new_user_request
        @agency = FactoryGirl.create :agency
        post :create, params: { auth_token: @admin.auth_token, new_user_request: @new_user_request_attributes }, format: :json
      end

      it "renders the json representation for the new_user_request record just created" do
        new_user_request_response = json_response
        expect(new_user_request_response[:email]).to eql @new_user_request_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created because email is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @new_user_request = FactoryGirl.create :new_user_request
        @invalid_user_attributes = { agency: 'Flock' }
        post :create, params: { auth_token: @admin.auth_token, new_user_request: @invalid_user_attributes }, format: :json
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

    context "when is not created because user already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @existing_user = FactoryGirl.create :user
        @new_user_request_attributes = FactoryGirl.attributes_for :new_user_request
        @new_user_request_attributes[:email] = @existing_user.email
        post :create, params: { auth_token: @admin.auth_token, new_user_request: @new_user_request_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors saying email already exists" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "Ya existe un usuario de tu agencia registrado"
      end

      it { should respond_with 422 }
    end

    context "when is not created because an AgencyAdmin from that Agency already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @existing_user = FactoryGirl.create :user
        @existing_user.email = Random.rand(10000).to_s+'@pcuervo.com'
        @existing_user.save
        @new_user_request_attributes = FactoryGirl.attributes_for :new_user_request
        @new_user_request_attributes[:email] = 'impostor@pcuervo.com'
        post :create, params: { auth_token: @admin.auth_token, new_user_request: @new_user_request_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors saying user already exists from that agency" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "Ya existe un usuario de tu agencia registrado"
      end

      it { should respond_with 422 }
    end
  end #POST create

  describe "POST #confirm_request" do
    context "when is successfully confirmed and new Agency user is created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @agency = FactoryGirl.create :agency
        @new_user_request = FactoryGirl.create :new_user_request
        @new_user_request.save!
        @user_attributes = FactoryGirl.attributes_for :user 
        @user_attributes[:email] = @new_user_request.email
        @user_attributes[:agency_id] = @agency.id
        post :confirm_request, params: { auth_token: @admin.auth_token, email: @new_user_request.email, agency_id: @agency.id, role: 2, is_member_amap: 0  }, format: :json
      end

      it "renders the json representation for the new_user_request record just created" do
        user_request_response = json_response
        expect(user_request_response[:email]).to eql @user_attributes[:email]
      end

      it "deletes NewUserRequest after User is created" do 
        expect( NewUserRequest.last.id ).to_not eql @new_user_request.id
      end

      it { should respond_with 201 }
    end

    context "when is successfully confirmed and new Brand user is created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @brand = FactoryGirl.create :brand
        @new_user_request = FactoryGirl.create :new_user_request
        @new_user_request.save!
        @user_attributes = FactoryGirl.attributes_for :user 
        @user_attributes[:email] = @new_user_request.email
        @user_attributes[:brand_id] = @brand.id
        post :confirm_request, params: { auth_token: @admin.auth_token, email: @new_user_request.email, brand_id: @brand.id, role: 4, is_member_amap: 0  }, format: :json
      end

      it "renders the json representation for the new_user_request record just created" do
        user_request_response = json_response
        expect(user_request_response[:email]).to eql @user_attributes[:email]
      end

      it "adds a new user to the brand" do
        user_request_response = json_response
        expect(@brand.users.count).to eql 1
      end

      it "deletes NewUserRequest after User is created" do 
        expect( NewUserRequest.last.id ).to_not eql @new_user_request.id
      end

      it { should respond_with 201 }
    end
  end # POST confirm_request

  describe "POST #reject_request" do
    context "when is successfully rejected and notifies user via email" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @agency = FactoryGirl.create :agency
        @new_user_request = FactoryGirl.create :new_user_request
        @new_user_request.save!
        @user_attributes = FactoryGirl.attributes_for :user 
        @user_attributes[:email] = @new_user_request.email
        @user_attributes[:agency_id] = @agency.id
        post :reject_request, params: { auth_token: @admin.auth_token, email: @new_user_request.email }, format: :json
      end

      it "renders a success message saying the user was rejected" do
        user_request_response = json_response
        expect(user_request_response).to have_key(:success)
      end

      it "deletes NewUserRequest after User is rejected" do 
        expect( NewUserRequest.last.id ).to_not eql @new_user_request.id
      end

      it { should respond_with :ok }
    end

    context "when is not rejected because NewUserRequest does not exist" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        post :reject_request, params: { auth_token: @admin.auth_token, email:  'invalid@email.com' }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors when no agency is present" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "No existe ninguna solicitud pendiente con ese email"
      end

      it { should respond_with 422 }
    end
  end # POST confirm_request
end
