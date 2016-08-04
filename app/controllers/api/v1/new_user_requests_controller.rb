module Api::V1
  class NewUserRequestsController < ApiController
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

    private
      # Only allow a trusted parameter "white list" through.
      def new_user_request_params
        params.require(:new_user_request).permit(:email, :agency, :user_type)
      end
  end
end