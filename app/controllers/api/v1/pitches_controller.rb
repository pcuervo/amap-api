class Api::V1::PitchesController < ApplicationController
  before_action :set_pitch, only: [:show, :update]
  before_action only: [:create, :update] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /pitches
  def index
    @pitches = Pitch.all
    render json: { pitches: @pitches }, except: [:created_at, :updated_at]
  end

  # GET /pitches/1
  def show
    if ! @pitch.present? 
      render json: { errors: 'No se encontró el pitch con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @pitch
  end

  # POST /pitches
  def create
    if ! params[:skill_categories].present?
      render json: { errors: { skill_categories: 'El pitch debe tener al menos una categoría de skills' } },status: :unprocessable_entity
      return
    end

    @pitch = Pitch.new(pitch_params)
    pitch_eval = PitchEvaluation.new
    @pitch.pitch_evaluations << pitch_eval

    params[:skill_categories].each do |skill_category_id|
      skill_cat = SkillCategory.find( skill_category_id )
      @pitch.skill_categories << skill_cat
    end

    if @pitch.save
      render json: @pitch, status: :created
      return
    end

    pitch_eval.destroy
    render json: { errors: @pitch.errors },status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pitch
      @pitch = Pitch.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pitch_params
      params.require(:pitch).permit( :name, :brief_date, :brief_email_contact, :brand_id )
    end

end