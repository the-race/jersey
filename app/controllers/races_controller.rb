class RacesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @race = current_user.races.find(params[:id])
  end

  def new
    @race = current_user.new_race
  end

  def create
    @race = current_user.races.new(params[:race])
    @race.athletes_attributes = params[:race][:athletes_attributes]
    if @race.save
      redirect_to dashboard_path, :notice => "Race created."
    else
      redirect_to new_race_path, :alert => "Unable to create race."
    end
  end
end
