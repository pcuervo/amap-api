class Api::V1::PitchEvaluationsController < ApplicationController
  before_action :set_pitch_evaluation, only: [:show, :update, :destroy, :average_per_month_by_agency]
  before_action only: [:create, :update, :by_user, :cancel, :decline, :search, :average_per_month_by_user, :average_per_month_by_agency, :average_per_month_industry] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /pitch_evaluations/1
  def show
    if ! @pitch_evaluation.present? 
      render json: { errors: 'No se encontró la evaluación con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @pitch_evaluation
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
    @pitch_evaluation.pitch_status = PitchEvaluation::ACTIVE

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
    
    #@pitch_evaluation.user_id = current_user.id
    @pitch_evaluation.evaluation_status = true
    @pitch_evaluation.pitch_status = PitchEvaluation::ACTIVE
    if @pitch_evaluation.update(pitch_evaluation_params)
      @pitch_evaluation.calculate_score
      render json: @pitch_evaluation, status: :ok
      return 
    end
    render json: { errors: @pitch_evaluation.errors }, status: :unprocessable_entity
  end

  # POST /by_user
  def by_user
    pitch_evaluations = PitchEvaluation.pitches_by_user( current_user.id, PitchEvaluation::ACTIVE )
    render json: pitch_evaluations, status: :ok
  end

  # POST /cancel
  def cancel
    pitch_evaluation = PitchEvaluation.find( params[:id] )
    pitch_evaluation.pitch_status = PitchEvaluation::CANCELLED
    pitch_evaluation.save
    render json: pitch_evaluation, status: :ok
  end

  # POST /decline
  def decline
    pitch_evaluation = PitchEvaluation.find( params[:id] )
    pitch_evaluation.pitch_status = PitchEvaluation::DECLINED
    pitch_evaluation.save
    render json: pitch_evaluation, status: :ok
  end

  # POST /archive
  def archive
    pitch_evaluation = PitchEvaluation.find( params[:id] )
    pitch_evaluation.pitch_status = PitchEvaluation::ARCHIVED
    pitch_evaluation.save
    render json: pitch_evaluation, status: :ok
  end

  # POST /destroy
  def destroy
    @pitch_evaluation.destroy
    head 204
  end

  # POST /filter
  def filter
    user = current_user
    @pitch_evaluation.filter
  end

  # POST /search
  def search
    if ! params[:keyword].present? 
      render json: { errors: 'Por favor ingresa una palabra clave para la búsqueda' },status: :unprocessable_entity
      return
    end
    pitch_evaluations = PitchEvaluation.search( current_user.id, params[:keyword] )
    render json: pitch_evaluations, status: :ok
  end

  # POST /average_per_month_by_user
  def average_per_month_by_user
    average_per_month = PitchEvaluation.average_per_month_by_user( current_user.id )
    render json: average_per_month, status: :ok
  end

  # POST /average_per_month_by_agency
  def average_per_month_by_agency
    agency = Agency.find( params[:id] )
    if ! agency.present? 
      render json: { errors: 'No se encontró la agencia con id: ' + params[:id].to_s },status: :unprocessable_entity
      return
    end

    user_ids = agency.users.pluck(:id)
    puts user_ids.join(",").to_yaml
    average_per_month = PitchEvaluation.average_per_month_by_agency( user_ids.join(",") )
    
    render json: { 'average_per_month': average_per_month, "agency_users": agency_users } , status: :ok
  end

  def average_per_month_industry
    average_per_month = PitchEvaluation.average_per_month_industry
    render json: average_per_month, status: :ok
  end

  private
    def set_pitch_evaluation
      @pitch_evaluation = PitchEvaluation.find_by_id(params[:id])
    end

    def pitch_evaluation_params
      params.require(:pitch_evaluation).permit( :pitch_id, :evaluation_status, :pitch_status, :are_objectives_clear, :time_to_present, :is_budget_known, :number_of_agencies, :are_deliverables_clear, :is_marketing_involved, :time_to_know_decision, :deliver_copyright_for_pitching, :know_presentation_rounds, :number_of_rounds, :score, :activity_status, :was_won, :has_selection_criteria )
    end
end