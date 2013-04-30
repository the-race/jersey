class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
    @races = current_user.races
  end
end
