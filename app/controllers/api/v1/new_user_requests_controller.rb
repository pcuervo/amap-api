module Api::V1
  class NewUserRequestsController < ApiController
    before_action :set_new_user_request, only: [:show, :update, :destroy]
    before_action :check_if_user_exists, only: [:create]
    before_action :check_if_agency_user_exists, only: [:create]
    after_action :send_confirmation_email, only: [:confirm_request]
    after_action :send_rejection_email, only: [:reject_request]

    # GET /new_user_requests/1
    def show
      render json: @new_user_request
    end

    # GET /new_user_requests
    def index
      @new_user_requests = NewUserRequest.all
      render json: @new_user_requests
    end

    # POST /new_user_requests
    def create
      if @user_exists
        render json: { errors: @user.errors }, status: :unprocessable_entity
        return
      end

      if @agency_user_exists
        render json: { errors: @user.errors }, status: :unprocessable_entity
        return
      end

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
      @new_user_request = NewUserRequest.find_by_email( params[:email] )

      if ! @new_user_request.present?
        invalid_user_request = NewUserRequest.new
        invalid_user_request.errors.add(:email, "No existe ninguna solicitud pendiente con ese email")
        render json: { errors: invalid_user_request.errors }, status: :unprocessable_entity
        return
      end

      @user = User.new( :email => @new_user_request.email, :role => params[:role].to_i, :is_member_amap => params[:is_member_amap] )

      if User::AGENCY_ADMIN == params[:role].to_i
        agency = Agency.find(params[:agency_id])
        @user.agencies << agency
      elsif User::CLIENT_ADMIN == params[:role].to_i
        brand = Brand.find(params[:brand_id])
        @user.brands << brand
      end

      @password = SecureRandom.hex
      @user.password = @password
      @user.password_confirmation = @password

      if @user.save
        @new_user_request.destroy
        render json: @user, status: :created, location: [:api, @user]
        return
      end

      render json: { errors: @user.errors }, status: :unprocessable_entity
    end

    # POST /reject_request
    def reject_request
      @new_user_request = NewUserRequest.find_by_email( params[:email] )
      if ! @new_user_request.present?
        invalid_user_request = NewUserRequest.new
        invalid_user_request.errors.add(:email, "No existe ninguna solicitud pendiente con ese email")
        render json: { errors: invalid_user_request.errors }, status: :unprocessable_entity
        return
      end

      @rejected_user_email = @new_user_request.email
      @new_user_request.destroy
      render json: { success: "Se ha rechazado el usuario con el correo " + @rejected_user_email + " correctamente."}, status: :ok
    end

    # GET /reject_request/agency_users
    def agency_users
      @new_user_requests = NewUserRequest.where('user_type = ?', "2")
      render json: @new_user_requests
    end

    # GET /reject_request/brand_users
    def brand_users
      @new_user_requests = NewUserRequest.where('user_type = ?', "4")
      render json: @new_user_requests
    end


    private
      # Only allow a trusted parameter "white list" through.
      def new_user_request_params
        params.require(:new_user_request).permit(:email, :agency_brand, :user_type)
      end

      def user_request_params
        params.require(:user).permit(:email, :role, :is_member_amap)
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_new_user_request
        @new_user_request = NewUserRequest.find(params[:id])
        puts @new_user_request.updated_at.to_yaml
      end

      def check_if_user_exists
        @user = User.find_by_email( params[:new_user_request][:email] )
        if @user.present?
          @user.errors.add(:email, "Ya existe una cuenta con ese email")
          @user_exists = true
        end
      end

      def check_if_agency_user_exists
        return if ! params[:new_user_request][:email].present?

        agency_domain = params[:new_user_request][:email].split('@')[1]
        agency_admin = User.where('email LIKE ? AND role = ?', '%'+agency_domain, User::AGENCY_ADMIN )

        if agency_admin.present?
          @user = agency_admin.first
          @user.errors.add(:email, "Ya existe un usuario de tu agencia registrado")
          @agency_user_exists = true
        end
      end

      def send_confirmation_email
        return if ! @user.present?
        return if ! @user.valid?
        UserRequestMailer.new_user_confirmation_email( @user, @password ).deliver_now
      end

      def send_rejection_email
        return if ! @rejected_user_email.present?
        UserRequestMailer.new_user_rejection_email( @rejected_user_email ).deliver_now
      end

  end
end