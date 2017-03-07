class Api::V1::PitchResultsController < ApplicationController
  before_action :set_pitch_result, only: [:show, :update]

  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end
  after_action :update_evaluation_won_status, only: [:create, :update], if: -> { ! @was_won.nil? }

  # GET /pitch_results/1
  def show
    if ! @pitch_result.present? 
      render json: { errors: 'No se encontraron los resultados con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @pitch_result
  end

  # POST /pitch_results
  def create
    @pitch_result = PitchResult.new(pitch_result_params)
    
    if @pitch_result.save
      @was_won = @pitch_result.was_pitch_won
      render json: @pitch_result, status: :created

      if ! @pitch_result.when_will_you_get_response.nil? 
        schedule_response_notification( @pitch_result )
      end
      
      return
    end

    render json: { errors: @pitch_result.errors },status: :unprocessable_entity
  end

  # POST /pitch_results/update
  def update
    if ! @pitch_result.present? 
      render json: { errors: 'No se encontraron los resultados con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    
    if @pitch_result.update(pitch_result_params)
      @was_won = @pitch_result.was_pitch_won
      render json: @pitch_result, status: :ok
      if ! @pitch_result.when_will_you_get_response.nil? 
        schedule_response_notification( @pitch_result )
      end

      return 
    end
    render json: { errors: @pitch_result.errors }, status: :unprocessable_entitys
  end

  private

    def set_pitch_result
      @pitch_result = PitchResult.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pitch_result_params
      params.require(:pitch_result).permit( :agency_id, :pitch_id, :was_proposal_presented, :got_response, :was_pitch_won, :got_feedback, :has_someone_else_won, :when_will_you_get_response, :when_are_you_presenting )
    end

    def update_evaluation_won_status
      agency = Agency.find( @pitch_result.agency_id )
      user_ids = []
      agency.users.each do |user|
        user_ids.push( user.id )
      end

      if @was_won
        lost_evaluations = PitchEvaluation.where('pitch_id = ?', @pitch_result.pitch_id).update_all(was_won: false)
      end
      pitch_evaluation = PitchEvaluation.where( 'user_id in (?) AND pitch_id = ?', user_ids, @pitch_result.pitch_id ).first
      pitch_evaluation.was_won = @was_won 
      pitch_evaluation.save
    end

    def schedule_response_notification pitch_result
      agency_users = pitch_result.agency.users
      agency_users.each do |u| 
        next if u.device_token == ''


        send_push_notification( u.device_token, '¿Has recibido fallo acerca del pitch "' + pitch_result.pitch.name + '"? No olvides actualizar la encuesta de resultados.', pitch_result.when_will_you_get_response  )
      end
    end
end
