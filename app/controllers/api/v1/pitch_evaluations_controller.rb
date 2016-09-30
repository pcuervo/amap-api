class Api::V1::PitchEvaluationsController < ApplicationController
  before_action :set_pitch_evaluation, only: [:show, :update]
  before_action only: [:create, :update, :by_user] do 
    authenticate_with_token! params[:auth_token]
  end

   # POST /pitch_evaluations
  def create
    existing_evaluation = PitchEvaluation.where( 'user_id = ? and pitch_id = ?', current_user.id, params[:pitch_evaluation][:pitch_id] )
    if existing_evaluation.present?
      render json: { errors: 'Ya existe una evaluación del pitch para este usuario.' },status: :unprocessable_entity
      return
    end
    @pitch_evaluation = PitchEvaluation.new(pitch_evaluation_params)
    @pitch_evaluation.user_id = current_user.id
    @pitch_evaluation.evaluation_status = true

    if @pitch_evaluation.save
      @pitch_evaluation.calculate_score
      render json: @pitch_evaluation, status: :created
      return
    end

    render json: { errors: @pitch_evaluation.errors },status: :unprocessable_entity
  end

  # POST /pitch_evaluations/update/
  def update
    if ! @pitch_evaluation.present? 
      render json: { errors: 'No se encontró la evaluación del pitch con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    
    @pitch_evaluation.evaluation_status = true
    if @pitch_evaluation.update(pitch_evaluation_params)
      @pitch_evaluation.calculate_score
      render json: @pitch_evaluation, status: :ok
      return 
    end
    render json: { errors: @pitch_evaluation.errors }, status: :unprocessable_entity
  end

  # POST /by_user
  def by_user
    pitch_evaluations = PitchEvaluation.pitches_by_user( current_user.id )
    render json: pitch_evaluations, status: :ok
  end

  private
    def set_pitch_evaluation
      @pitch_evaluation = PitchEvaluation.find_by_id(params[:id])
    end

    def pitch_evaluation_params
      params.require(:pitch_evaluation).permit( :pitch_id, :evaluation_status, :pitch_status, :are_objectives_clear, :time_to_present, :is_budget_known, :number_of_agencies, :are_deliverables_clear, :is_marketing_involved, :time_to_know_decision, :deliver_copyright_for_pitching, :know_presentation_rounds, :number_of_rounds, :score, :activity_status, :was_won, :has_selection_criteria )
    end
end