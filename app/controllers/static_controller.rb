class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def terms
  end

  def privacy
  end

  def not_found
  end
end
