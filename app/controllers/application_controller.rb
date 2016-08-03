class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  include Authenticable

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Required for Serialization - gem active_model_serializers
  include ActionController::Serialization

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
  end
end
