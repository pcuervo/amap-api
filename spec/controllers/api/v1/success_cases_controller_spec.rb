require 'rails_helper'

RSpec.describe Api::V1::SuccessCasesController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_success_cases = SuccessCase.all.count
      get :index
    end

    it "returns all SuccessCases from the database" do
      success_cases_response = json_response
      expect(success_cases_response[:success_cases].size).to eq( @total_success_cases )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @success_case = FactoryGirl.create :success_case
      get :show, { id: @success_case.id }, format: :json
    end

    it "returns the information about a success_case on a hash" do
      expect(json_response[:name]).to eql @success_case.name
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case_attributes = FactoryGirl.attributes_for :success_case
        success_case = FactoryGirl.create :success_case
        #@success_case_attributes[:success_case_id] = success_case.id
        agency = FactoryGirl.create :agency
        @success_case_attributes[:agency_id] = agency.id
        post :create, { auth_token: @admin.auth_token, success_case: @success_case_attributes }, format: :json
      end

      it "renders the json representation for the success_case record just created" do
        success_case_response = json_response
        expect(success_case_response[:name]).to eql @success_case_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name and or description is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case_attributes = FactoryGirl.attributes_for :success_case
        success_case = FactoryGirl.create :success_case
        @success_case_attributes[:success_case_id] = success_case.id
        @success_case_attributes[:name] = ''
        @success_case_attributes[:description] = ''
        post :create, { auth_token: @admin.auth_token, success_case: @success_case_attributes }, format: :json
      end

      it "renders an errors json" do
        success_case_response = json_response
        expect(success_case_response).to have_key(:errors)
      end

      it "renders the json errors when no case name is present" do
        success_case_response = json_response
        expect(success_case_response[:errors][:name]).to include "El nombre del caso no puede estar vacío"
        expect(success_case_response[:errors][:description]).to include "La descripción no puede estar vacía"
      end

      it { should respond_with 422 }
    end
  end #POST create

  describe "POST #update" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case = FactoryGirl.create :success_case
        @new_name = 'Super Cool Case'
        post :update, { auth_token: @admin.auth_token, id: @success_case.id,
                        success_case: { name: @new_name } }, format: :json
      end

      it "renders the json representation for the success_case record just updated" do
        success_case_response = json_response
        expect(success_case_response[:name]).to eql @new_name
      end

      it { should respond_with 200 }
    end

    context "when is not updated because new name is empty" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case = FactoryGirl.create :success_case
        post :update, { auth_token: @admin.auth_token, id: @success_case.id,
                        success_case: { num_employees: 10, name: '' } }, format: :json
      end

      it "renders an errors json" do
        success_case_response = json_response
        expect(success_case_response).to have_key(:errors)
      end

      it "renders the json errors when no success_case name is present" do
        success_case_response = json_response
        expect(success_case_response[:errors][:name]).to include "El nombre del caso no puede estar vacío"
      end

      it { should respond_with 422 }
    end
  end #POST update

  describe "POST #destroy" do
    context "when is successfully destroyed" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case = FactoryGirl.create :success_case
        post :destroy, { auth_token: @admin.auth_token, id: @success_case.id }, format: :json
      end

      it { should respond_with 204 }
    end

    context "when is not destroyed because no SuccessCase was found" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @success_case = FactoryGirl.create :success_case
        post :destroy, { auth_token: @admin.auth_token, id: 829383 }, format: :json
      end

      it "renders an errors json" do
        success_case_response = json_response
        expect(success_case_response).to have_key(:errors)
      end

      it "renders the json errors when no success_case name is present" do
        success_case_response = json_response
        expect(success_case_response[:errors]).to include "No se encontró ningún case de éxito con id: 829383"
      end

      it { should respond_with 422 }
    end
  end #POST update

end
