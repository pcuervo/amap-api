require 'rails_helper'

RSpec.describe Api::V1::BrandsController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_brands = Brand.all.count
      get :index
    end

    it "returns all Brands from the database" do
      brands_response = json_response
      expect(brands_response[:brands].size).to eq( @total_brands )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @brand = FactoryGirl.create :brand
      get :show, params: { id: @brand.id }, format: :json
    end

    it "returns the information about a Brand on a hash" do
      expect(json_response[:name]).to eql @brand.name
    end

    it "returns the Company of the Brand" do 
      brand_response = json_response
      expect(brand_response).to have_key(:company)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @brand_attributes = FactoryGirl.attributes_for :brand
        @company = FactoryGirl.create :company
        @brand_attributes[:company_id] = @company.id
        post :create, params: { auth_token: @admin.auth_token, brand: @brand_attributes }, format: :json
      end

      it "renders the json representation for the brand record just created" do
        brand_response = json_response
        expect(brand_response[:name]).to eql @brand_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @brand_attributes = FactoryGirl.attributes_for :brand
        @brand_attributes[:name] = ''
        post :create, params: { auth_token: @admin.auth_token, brand: @brand_attributes }, format: :json
      end

      it "renders an errors json" do
        brand_response = json_response
        expect(brand_response).to have_key(:errors)
      end

      it "renders the json errors when no brand name is present" do
        brand_response = json_response
        expect(brand_response[:errors][:name]).to include "El nombre de la marca no puede estar vacío"
      end

      it { should respond_with 422 }
    end

    context "when is not created because company is not present or does not exist" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @brand_attributes = FactoryGirl.attributes_for :brand
        post :create, params: { auth_token: @admin.auth_token, brand: @brand_attributes }, format: :json
      end

      it "renders an errors json" do
        brand_response = json_response
        expect(brand_response).to have_key(:errors)
      end

      it "renders the json errors when no brand name is present" do
        brand_response = json_response
        expect(brand_response[:errors][:company]).to include "La compañía es obligatoria"
      end

      it { should respond_with 422 }
    end
  end #POST create

  describe "GET #by_company" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @brand = Brand.last
      get :by_company, params: { id: @brand.company_id }, format: :json
    end

    it "returns the information about a Brand on a hash" do
      expect(json_response[:name]).to eql @brand.name
    end

    it "returns the Company of the Brand" do 
      brand_response = json_response
      expect(brand_response).to have_key(:company)
    end

    it { should respond_with 200 }
  end

  describe "POST #unify" do
    context "when brands are successfully unified" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @correct_brand = FactoryGirl.create :brand
        @incorrect_brand = FactoryGirl.create :brand
        3.times.each do |i|
          p = FactoryGirl.create :pitch
          @incorrect_brand.pitches << p
        end
        @incorrect_brand.save
        @brand = FactoryGirl.create :brand
        post :unify, params: { auth_token: @admin.auth_token, id: @brand.id, incorrect_brand_id: @incorrect_brand.id }, format: :json
      end

      it "returns a Brand object with the new brands added" do
        brand_response = json_response
        expect(brand_response[:pitches].count).to eql 3
        expect{ Brand.find(@incorrect_brand.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { should respond_with 200 }
    end
  end #POST unify
end
