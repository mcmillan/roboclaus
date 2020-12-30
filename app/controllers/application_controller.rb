class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_devise_parameter_sanitizer, if: :devise_controller?
  before_action :redirect_if_out_of_season
  http_basic_authenticate_with name: 'christmas', password: 'christmaschristmas', if: :requires_basic_auth?

  private

  def redirect_if_out_of_season
    return if Season.christmas?

    redirect_to root_url, warning: 'Roboclaus is done for the year. See you next December!'
  end

  def configure_devise_parameter_sanitizer
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name address])
  end

  def requires_basic_auth?
    return false unless Rails.env.production?
    return false unless ENV['REQUIRE_BASIC_AUTH_FOR_NON_ADMINS'] == 'true'
    return false if user_signed_in? && current_user.admin?

    true
  end
end
