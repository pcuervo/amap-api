require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Api::V1::AgenciesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Agency. As you add validations to Agency, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AgenciesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_agencies = Agency.all.count
      get :index
    end

    it "returns 5 unit items from the database" do
      agencies_response = json_response
      expect(agencies_response[:agencies].size).to eq( @total_agencies )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @agency = FactoryGirl.create :agency
      get :show, { id: @agency.id }, format: :json
    end

    it "returns the information about a agency on a hash" do
      expect(json_response[:name]).to eql @agency.name
    end

    it "returns the success cases of the agency" do 
      agency_response = json_response
      puts agency_response.to_yaml
      expect(agency_response).to have_key(:success_cases)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @agency_attributes = FactoryGirl.attributes_for :agency
        post :create, { auth_token: @admin.auth_token, agency: @agency_attributes }, format: :json
      end

      it "renders the json representation for the agency record just created" do
        agency_response = json_response
        expect(agency_response[:name]).to eql @agency_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @agency_attributes = FactoryGirl.attributes_for :agency
        @agency_attributes[:name] = ''
        post :create, { auth_token: @admin.auth_token, agency: @agency_attributes }, format: :json
      end

      it "renders an errors json" do
        agency_response = json_response
        expect(agency_response).to have_key(:errors)
      end

      it "renders the json errors when no agency name is present" do
        agency_response = json_response
        expect(agency_response[:errors][:name]).to include "El nombre de la agencia no puede estar vacío"
      end

      it { should respond_with 422 }
    end

    context "when is not created because name already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        existing_agency = FactoryGirl.create :agency
        @agency_attributes = FactoryGirl.attributes_for :agency
        @agency_attributes[:name] = existing_agency.name
        post :create, { auth_token: @admin.auth_token, agency: @agency_attributes }, format: :json
      end

      it "renders an errors json" do
        agency_response = json_response
        expect(agency_response).to have_key(:errors)
      end

      it "renders the json errors saying an agency already exists with that name" do
        agency_response = json_response
        expect(agency_response[:errors][:name]).to include "Ya existe una agencia con ese nombre"
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

        @agency = FactoryGirl.create :agency
        @new_name = 'SuperCoolAgency' + Random.rand(1000).to_s
        post :update, { auth_token: @admin.auth_token, id: @agency.id,
                        agency: { num_employees: 10, name: @new_name } }, format: :json
      end

      it "renders the json representation for the agency record just updated" do
        agency_response = json_response
        expect(agency_response[:name]).to eql @new_name
      end

      it { should respond_with 200 }
    end

    context "when is not updated because name already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @agency = FactoryGirl.create :agency
        @another_agency = FactoryGirl.create :agency
        post :update, { auth_token: @admin.auth_token, id: @agency.id,
                        agency: { num_employees: 10, name: @another_agency.name } }, format: :json
      end

      it "renders an errors json" do
        agency_response = json_response
        expect(agency_response).to have_key(:errors)
      end

      it "renders the json errors when no agency name is present" do
        agency_response = json_response
        expect(agency_response[:errors][:name]).to include "Ya existe una agencia con ese nombre"
      end

      it { should respond_with 422 }
    end

  end #POST update

end
