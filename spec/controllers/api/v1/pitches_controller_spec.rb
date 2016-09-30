require 'rails_helper'

RSpec.describe Api::V1::PitchesController, :type => :controller do
  describe "GET #index" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @total_pitches = Pitch.all.count
      get :index
    end

    it "returns all pitches from the database" do
      pitches_response = json_response
      expect(pitches_response[:pitches].size).to eq( @total_pitches )
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      api_key = ApiKey.create
      api_authorization_header 'Token ' + api_key.access_token
      @pitch = FactoryGirl.create :pitch
      get :show, params: { id: @pitch.id }, format: :json
    end

    it "returns the information about a Pitch on a hash" do
      expect(json_response[:name]).to eql @pitch.name
      expect(json_response[:brief_date]).to eql @pitch.brief_date.strftime('%F')
      expect(json_response[:brief_email_contact]).to eql @pitch.brief_email_contact
    end

    it "returns the SkillCategories of the pitch" do 
      pitch_response = json_response
      expect(pitch_response).to have_key(:skill_categories)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch_attributes = FactoryGirl.attributes_for :pitch
        @skill_category = SkillCategory.last
        @brand = Brand.last
        @pitch_attributes[:skill_category_id] = @skill_category.id
        @pitch_attributes[:brand_id] = @brand.id
        skill_categories_arr = [ SkillCategory.first.id ]
        post :create, params: { auth_token: @admin.auth_token, pitch: @pitch_attributes, skill_categories: skill_categories_arr }, format: :json
      end

      it "renders the json representation for the pitch record just created" do
        pitch_response = json_response
        expect(pitch_response[:name]).to eql @pitch_attributes[:name]
      end

      it "should have at least one SkillCategory" do
        pitch_response = json_response
        expect(pitch_response[:skill_categories].count).to be > 0
      end

      it "should return an EvaluationPitch" do
        puts json_response.to_yaml
        pitch_response = json_response
        expect(pitch_response).to have_key(:pitch_evaluations)
      end

      it { should respond_with 201 }
    end

    context "when is not created because name is not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch_attributes = FactoryGirl.attributes_for :pitch
        @skill_category = SkillCategory.last
        @brand = Brand.last
        @pitch_evaluations_total = PitchEvaluation.all.count
        @pitch_attributes[:skill_category_id] = @skill_category.id
        @pitch_attributes[:brand_id] = @brand.id
        @pitch_attributes[:name] = ''
        skill_categories_arr = [ SkillCategory.first.id ]
        post :create, params: { auth_token: @admin.auth_token, pitch: @pitch_attributes, skill_categories: skill_categories_arr }, format: :json
      end

      it "renders an errors json" do
        pitch_response = json_response
        expect(pitch_response).to have_key(:errors)
      end

      it "renders the json errors when no pitch name is present" do
        pitch_response = json_response
        expect(pitch_response[:errors][:name]).to include "El nombre no puede estar vacío"
      end

      it "should not create a PitchEvaluation" do
        expect(@pitch_evaluations_total).to eq PitchEvaluation.all.count
      end

      it { should respond_with 422 }
    end

    context "when is not created because SkillCategories are not present" do
      before(:each) do
        api_key = ApiKey.create
        api_authorization_header 'Token ' + api_key.access_token
        @admin = FactoryGirl.create :user

        @pitch_attributes = FactoryGirl.attributes_for :pitch
        @skill_category = SkillCategory.last
        @brand = Brand.last
        @pitch_evaluations_total = PitchEvaluation.all.count
        @pitch_attributes[:skill_category_id] = @skill_category.id
        @pitch_attributes[:brand_id] = @brand.id
        post :create, params: { auth_token: @admin.auth_token, pitch: @pitch_attributes }, format: :json
      end

      it "renders an errors json" do
        pitch_response = json_response
        expect(pitch_response).to have_key(:errors)
      end

      it "renders the json errors when no pitch name is present" do
        pitch_response = json_response
        expect(pitch_response[:errors][:skill_categories]).to include "El pitch debe tener al menos una categoría de skills"
      end

      it { should respond_with 422 }
    end
  end #POST create
  
end 
