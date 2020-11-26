class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_devise_parameter_sanitizer, if: :devise_controller?

  private

  def configure_devise_parameter_sanitizer
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name address])
  end
end
