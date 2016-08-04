class ApplicationController < ActionController::API
  before_action :restrict_access

  include ActionController::RequestForgeryProtection
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  include Authenticable

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Required for Serialization - gem active_model_serializers
  include ActionController::Serialization

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
  end

  private 

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end

end
