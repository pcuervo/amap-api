module Api::V1
  class UsersController < ApiController
    before_action :set_user, only: [:show, :update, :destroy]
    #before_action :authenticate_with_token!

    # GET /users/1
    def show
      render json: @user
    end

    def index
      @users = User.all
      render json: @users
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.fetch(:user, {})
      end

  end 
end 

