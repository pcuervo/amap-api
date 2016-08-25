require 'rails_helper'

RSpec.describe Api::V1::SkillsController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_skills = Skill.all.count
      get :index
    end

    it "returns all Skills from the database" do
      skills_response = json_response[:skills]
      expect(skills_response.size).to eq( @total_skills )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @skill = FactoryGirl.create :skill
      get :show, { id: @skill.id }, format: :json
    end

    it "returns the information about a skill on a hash" do
      expect(json_response[:name]).to eql @skill.name
    end

    it "returns the SkillCategory of the Skill" do 
      skill_response = json_response
      expect(skill_response).to have_key(:skill_category)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @skill_attributes = FactoryGirl.attributes_for :skill
        skill_category = FactoryGirl.create :skill_category
        @skill_attributes[:skill_category_id] = skill_category.id
        post :create, { auth_token: @admin.auth_token, skill: @skill_attributes }, format: :json
      end

      it "renders the json representation for the skill record just created" do
        skill_response = json_response
        expect(skill_response[:name]).to eql @skill_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created because name or SkillCategory is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @skill_attributes = FactoryGirl.attributes_for :skill
        @skill_attributes[:name] = ''
        post :create, { auth_token: @admin.auth_token, skill: @skill_attributes }, format: :json
      end

      it "renders an errors json" do
        puts '_____'
        puts 'we ever here'
        skill_response = json_response
        expect(skill_response).to have_key(:errors)
      end

      it "renders the json errors when no skill name or SkillCategory is present" do
        skill_response = json_response
        puts json_response.to_yaml
        expect(skill_response[:errors][:name]).to include "El nombre del skill no puede estar vacío"
        expect(skill_response[:errors][:skill_category]).to include "La categoría es obligatoria"
      end

      it { should respond_with 422 }
    end

    context "when is not created because name already exists" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        existing_skill = FactoryGirl.create :skill
        @skill_attributes = FactoryGirl.attributes_for :skill
        @skill_attributes[:name] = existing_skill.name
        post :create, { auth_token: @admin.auth_token, skill: @skill_attributes }, format: :json
      end

      it "renders an errors json" do
        skill_response = json_response
        expect(skill_response).to have_key(:errors)
      end

      it "renders the json errors saying an skill already exists with that name" do
        skill_response = json_response
        expect(skill_response[:errors][:name]).to include "Ya existe un skill con ese nombre"
      end

      it { should respond_with 422 }
    end

  end #POST create
end
