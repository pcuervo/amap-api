class Api::V1::PitchWinnerSurveysController < ApplicationController
  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end

  # POST /pitch_winner_surveys
  def create

    @pitch_winner_survey = PitchWinnerSurvey.new(pitch_winner_surveys_params)
    
    if @pitch_winner_survey.save
      render json: @pitch_winner_survey, status: :created
      return
    end
    puts @pitch_winner_survey.errors.to_yaml
    render json: { errors: @pitch_winner_survey.errors },status: :unprocessable_entity
  end

  private

    # Only allow a trusted parameter "white list" through.
    def pitch_winner_surveys_params
      params.require(:pitch_winner_survey).permit( :was_contract_signed, :contract_signature_date, :was_project_activated, :when_will_it_activate, :pitch_id, :agency_id )
    end
end
