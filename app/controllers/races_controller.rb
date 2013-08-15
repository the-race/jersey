class RacesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def show
    @race = Race.find params[:id]
    @race.check_and_update_totals(gateway, interval)
    @race = RaceDecorator.new(@race, interval)
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

  private

  def gateway
    StravaAsyncGateway.new
  end

  def interval
    Interval.create_from(params)
  end

end
