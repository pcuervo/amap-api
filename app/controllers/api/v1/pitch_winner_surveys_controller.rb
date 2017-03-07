class Api::V1::PitchWinnerSurveysController < ApplicationController
  before_action :set_pitch_winner_survey, only: [:show, :update]
  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /pitch_winner_surveys/1
  def show
    if ! @pitch_winner_survey.present? 
      render json: { errors: 'No se encontraron los resultados con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @pitch_winner_survey
  end

  # POST /pitch_winner_surveys
  def create

    @pitch_winner_survey = PitchWinnerSurvey.new(pitch_winner_surveys_params)
    
    if @pitch_winner_survey.save
      render json: @pitch_winner_survey, status: :created
      return
    end
    render json: { errors: @pitch_winner_survey.errors },status: :unprocessable_entity
  end

  # POST /pitch_winner_surveys/update
  def update
    if ! @pitch_winner_survey.present? 
      render json: { errors: 'No se encontraron los resultados con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    
    if @pitch_winner_survey.update(pitch_winner_surveys_params)
      render json: @pitch_winner_survey, status: :ok
      return 
    end
    render json: { errors: @pitch_winner_survey.errors }, status: :unprocessable_entitys
  end

  private
    def set_pitch_winner_survey
      @pitch_winner_survey = PitchWinnerSurvey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pitch_winner_surveys_params
      params.require(:pitch_winner_survey).permit( :was_contract_signed, :contract_signature_date, :was_project_activated, :when_will_it_activate, :pitch_id, :agency_id )
    end
end
