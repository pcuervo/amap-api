class Api::V1::SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :update, :destroy]
  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /skills
  def index
    @skills = Skill.all
    render json: { skills: @skills },  :include => { :skill_category => { :only => [:name, :id] } }, :except => [:updated_at]
  end

  # GET /skills/1
  def show
    if ! @skill.present? 
      render json: { errors: 'No existe ningún skill con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @skill, :include => { :skill_category => { :include => { :only => :name } } }
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)
    
    if @skill.save
      render json: @skill, :include => { :skill_category => { :only => :name } }, :except => [:created_at, :updated_at], status: :created
      return
    end

    render json: { errors: @skill.errors },status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def skill_params
      params.require(:skill).permit( :name, :skill_category_id )
    end
end

