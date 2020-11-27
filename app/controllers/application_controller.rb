class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_devise_parameter_sanitizer, if: :devise_controller?
  before_action :reject_non_admins

  private

  def configure_devise_parameter_sanitizer
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name address])
  end

  def reject_non_admins
    return unless Rails.env.production?
    return if user_signed_in? && current_user.admin?
    return if controller_path == 'devise/sessions'

    head :service_unavailable
  end
end
