class Api::V1::PitchEvaluationsController < ApplicationController
  before_action :set_pitch_evaluation, only: [:show, :update]
  before_action only: [:create, :update] do 
    authenticate_with_token! params[:auth_token]
  end

   # POST /pitch_evaluations
  def create
    @pitch_evaluation = PitchEvaluation.new(pitch_evaluation_params)

    if @pitch_evaluation.save
      render json: @pitch_evaluation, status: :created
      return
    end

    render json: { errors: @pitch_evaluation.errors },status: :unprocessable_entity
  end

  # POST /pitch_evaluations/update/1
    def update
      if ! @pitch_evaluation.present? 
        render json: { errors: 'No se encontró la evaluación del pitch con id: ' + params[:id] },status: :unprocessable_entity
        return
      end
      
      if @pitch_evaluation.update(pitch_evaluation_params)
        render json: @pitch_evaluation, status: :ok
        return 
      end
      render json: { errors: @pitch_evaluation.errors }, status: :unprocessable_entity
    end

  private
    def set_pitch_evaluation
      @pitch_evaluation = PitchEvaluation.find_by_id(params[:id])
    end

    def pitch_evaluation_params
      params.require(:pitch_evaluation).permit( :pitch_id, :evaluation_status, :pitch_status, :are_objectives_clear, :days_to_present, :is_budget_known, :number_of_agencies, :are_deliverables_clear, :is_marketing_involved, :days_to_know_decision, :deliver_copyright_for_pitching, :know_presentation_rounds, :number_of_rounds, :score, :activity_status, :was_won )
    end
end
