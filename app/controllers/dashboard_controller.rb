class DashboardController < ApplicationController
  def show
    @user = User.first
  end
end
