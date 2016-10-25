class Api::V1::PitchResultsController < ApplicationController
  before_action only: [:create] do 
    authenticate_with_token! params[:auth_token]
  end
  after_action :update_evaluation_to_won, only: [:create], if: -> { @was_won }

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

  private
    # Only allow a trusted parameter "white list" through.
    def pitch_result_params
      params.require(:pitch_result).permit( :agency_id, :pitch_id, :was_proposal_presented, :got_response, :was_pitch_won, :got_feedback, :has_someone_else_won, :when_will_you_get_response, :when_are_you_presenting )
    end

    def update_evaluation_to_won
      agency = Agency.find( @pitch_result.agency_id )
      user_ids = []
      agency.users.each do |user|
        user_ids.push( user.id )
      end
      pitch_evaluation = PitchEvaluation.where( 'user_id in (?) AND pitch_id = ?', user_ids, @pitch_result.pitch_id ).first
      pitch_evaluation.was_won = true 
      pitch_evaluation.save
    end
end
