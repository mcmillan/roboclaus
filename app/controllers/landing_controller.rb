class LandingController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_if_authenticated

  def index; end

  private

  def redirect_if_authenticated
    return unless user_signed_in?

    redirect_to groups_path
  end
end
