module Api::V1
  class NewUserRequestsController < ApiController
    before_action :set_new_user_request, only: [:show, :update, :destroy]

    # GET /new_user_requests/1
    def show
      render json: @new_user_request
    end

    # GET /new_user_requests
    def index
      @new_user_requests = NewUserRequest.all
      render json: @new_user_requests
    end

    # POST /agencies
    def create
      @new_user_request = NewUserRequest.new( new_user_request_params )

      if @new_user_request.save
        UserRequestMailer.new_user_request_email( @new_user_request ).deliver_now
        render json: @new_user_request, status: :created
        return
      end
      render json: { errors: @new_user_request.errors }, status: :unprocessable_entity
    end

    # POST /confirm_request
    def confirm_request
      @new_user_request
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: [:api, @user]
        return
      end
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end

    private
      # Only allow a trusted parameter "white list" through.
      def new_user_request_params
        params.require(:new_user_request).permit(:email, :agency, :user_type)
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_new_user_request
        @new_user_request = NewUserRequest.find(params[:id])
      end
  end
end