class Api::V1::SkillCategoriesController < ApplicationController
  before_action :set_skill_category, only: [:show]
  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /skill_categories
  def index
    @skill_categories = SkillCategory.all
    render json: { skill_categories: @skill_categories }, :include => { :skills => { :only => [:name, :id] } }, :except => [:updated_at]

  end

  # GET /skill_categories/1
  def show
    if ! @skill_category.present? 
      render json: { errors: 'No se encontró ninguna categoría de skills con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @skill_category
  end

  # POST /skill_categories
  def create
    @skill_category = SkillCategory.new(skill_category_params)
    
    if @skill_category.save
      render json: @skill_category, status: :created
      return
    end

    render json: { errors: @skill_category.errors },status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill_category
      @skill_category = SkillCategory.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def skill_category_params
      params.require(:skill_category).permit( :name )
    end
end
