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

    # POST /agencies
    def create
      puts 'we are creting'
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: [:api, @user]
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :agency_id)
      end

  end 
end 

