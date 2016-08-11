module Api::V1
  class UsersController < ApiController
    before_action :set_user, only: [:show, :update, :destroy]
    before_action only: [:create, :update, :confirm_user_request] do 
      authenticate_with_token! params[:auth_token]
    end

    # GET /users/1
    def show
      render json: @user
    end

    # GET /users
    def index
      @users = User.all
      render json: @users
    end

    # POST /create
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: [:api, @user]
        return
      end
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end

    def update
      user = User.find( params[:id] )

      if user.update( user_params )
        render json: user, status: 200, location: [:api, user]
        return        
      end

      render json: { errors: user.errors }, status: :unprocessable_entity
    end

    def send_password_reset
      user = User.find_by_email( params[:email] )
      if user
        user.send_password_reset
        render json: { success: 'Se ha enviado un correo con instrucciones para restablecer contraseña' }, status: 200, location: [:api, user]
        return
      end
      user = User.new
      user.errors.add(:email, "No existe ningún usuario con ese email")
      render json: { errors: user.errors }, status: :unprocessable_entity
    end

    def reset_password
      @user = User.find_by_reset_password_token(params[:token])

      if ! @user.present?
        invalid_user = User.new
        invalid_user.errors.add(:reset_password_token, "¡El código para cambiar tu contraseña es inválido!")
        render json: { errors: invalid_user.errors }, status: :unprocessable_entity
        return
      end

      @user.password = params[:password]
      if @user.save!
        render json: { success: '¡Se ha cambiado tu contraseña exitosamente!' }, status: 200, location: [:api, @user]
        return
      end
      
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :is_member_amap, :agency_id)
      end

  end 
end 

