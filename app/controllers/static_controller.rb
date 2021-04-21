class StaticController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_if_out_of_season

  def terms; end

  def privacy; end

  def error
    @code = params[:code]
    render status: @code
  end
end
