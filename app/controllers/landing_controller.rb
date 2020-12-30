class LandingController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_if_out_of_season
  before_action :redirect_if_authenticated

  def index; end

  private

  def redirect_if_authenticated
    return unless user_signed_in? && Season.christmas?

    redirect_to groups_path
  end
end
