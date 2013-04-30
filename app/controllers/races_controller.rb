class RacesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @race = current_user.new_race
  end

  def create
    race = current_user.races.new(params[:race])
    require 'pry'; binding.pry
    if race.save
      redirect_to dashboard_path, :notice => "Race created."
    else
      redirect_to new_race_path, :alert => "Unable to create race." + race.errors.full_messages.to_s
    end
  end
end
