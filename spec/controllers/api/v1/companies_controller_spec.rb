require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_companies = Company.all.count
      get :index
    end

    it "returns all companies from the database" do
      companies_response = json_response
      expect(companies_response[:companies].size).to eq( @total_companies )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @company = FactoryGirl.create :company
      get :show, params: { id: @company.id }, format: :json
    end

    it "returns the information about a company on a hash" do
      expect(json_response[:name]).to eql @company.name
    end

    it "returns the brands of the company" do 
      company_response = json_response
      expect(company_response).to have_key(:brands)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @company_attributes = FactoryGirl.attributes_for :company
        post :create, params: { auth_token: @admin.auth_token, company: @company_attributes }, format: :json
      end

      it "renders the json representation for the company record just created" do
        company_response = json_response
        expect(company_response[:name]).to eql @company_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @company_attributes = FactoryGirl.attributes_for :company
        @company_attributes[:name] = ''
        post :create, params: { auth_token: @admin.auth_token, company: @company_attributes }, format: :json
      end

      it "renders an errors json" do
        company_response = json_response
        expect(company_response).to have_key(:errors)
      end

      it "renders the json errors when no company name is present" do
        company_response = json_response
        expect(company_response[:errors][:name]).to include "El nombre de la compañía no puede estar vacío"
      end

      it { should respond_with 422 }
    end

  end #POST create

  describe "POST #add_favorite_agency" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @company = FactoryGirl.create :company
        @admin.companies << @company
        @admin.save
        @agency = FactoryGirl.create :agency
        post :add_favorite_agency, params: { auth_token: @admin.auth_token, id: @company.id, agency_id: @agency.id }, format: :json
      end

      it "returns a Company object with the agency as favorite" do
        company_response = json_response
        expect(company_response[:favorite_agencies][0][:id]).to eql @agency.id
      end

      it { should respond_with 201 }
    end
  end #POST add_favorite
end
