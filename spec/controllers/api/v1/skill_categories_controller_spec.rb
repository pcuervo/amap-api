require 'rails_helper'

RSpec.describe Api::V1::SkillCategoriesController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_skill_categories = SkillCategory.all.count
      get :index
    end

    it "returns 5 unit items from the database" do
      skill_categories_response = json_response[:skill_categories]
      expect(skill_categories_response.size).to eq( @total_skill_categories )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @skill_category = FactoryGirl.create :skill_category
      get :show, { id: @skill_category.id }, format: :json
    end

    it "returns the information about a skill_category on a hash" do
      expect(json_response[:name]).to eql @skill_category.name
    end

    it "returns the success cases of the skill_category" do 
      skill_category_response = json_response
      expect(skill_category_response).to have_key(:skills)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @skill_category_attributes = FactoryGirl.attributes_for :skill_category
        post :create, { auth_token: @admin.auth_token, skill_category: @skill_category_attributes }, format: :json
      end

      it "renders the json representation for the skill_category record just created" do
        skill_category_response = json_response
        expect(skill_category_response[:name]).to eql @skill_category_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @skill_category_attributes = FactoryGirl.attributes_for :skill_category
        @skill_category_attributes[:name] = ''
        post :create, { auth_token: @admin.auth_token, skill_category: @skill_category_attributes }, format: :json
      end

      it "renders an errors json" do
        skill_category_response = json_response
        expect(skill_category_response).to have_key(:errors)
      end

      it "renders the json errors when no skill_category name is present" do
        skill_category_response = json_response
        expect(skill_category_response[:errors][:name]).to include "El nombre de la categoría no puede estar vacío"
      end

      it { should respond_with 422 }
    end

    context "when is not created because name already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        existing_skill_category = FactoryGirl.create :skill_category
        @skill_category_attributes = FactoryGirl.attributes_for :skill_category
        @skill_category_attributes[:name] = existing_skill_category.name
        post :create, { auth_token: @admin.auth_token, skill_category: @skill_category_attributes }, format: :json
      end

      it "renders an errors json" do
        skill_category_response = json_response
        expect(skill_category_response).to have_key(:errors)
      end

      it "renders the json errors saying an skill_category already exists with that name" do
        skill_category_response = json_response
        expect(skill_category_response[:errors][:name]).to include "Ya existe una categoría con ese nombre"
      end

      it { should respond_with 422 }
    end

  end #POST create
end
