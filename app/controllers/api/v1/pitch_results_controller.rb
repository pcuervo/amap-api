class Api::V1::PitchResultsController < ApplicationController
  before_action :set_pitch_result, only: [:show, :update]

  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end
  after_action :update_evaluation_won_status, only: [:create, :update], if: -> { @was_won.present? }

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
      puts 'are we ever here?'
      agency = Agency.find( @pitch_result.agency_id )
      user_ids = []
      agency.users.each do |user|
        user_ids.push( user.id )
      end
      pitch_evaluation = PitchEvaluation.where( 'user_id in (?) AND pitch_id = ?', user_ids, @pitch_result.pitch_id ).first
      pitch_evaluation.was_won = @was_won 
      pitch_evaluation.save
    end
end
