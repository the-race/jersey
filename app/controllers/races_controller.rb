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

  def update
    @race = current_user.races.find(params[:id])
    @race.force_update_totals(gateway, interval)
    redirect_to race_path(@race, interval.to_params)
  end

  private
  def gateway
    Jersey::StravaAsyncGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD'])
  end

  def interval
    Interval.new(year, week)
  end

  def year
    params[:year] ? params[:year].to_i : Time.new.year
  end

  def week
    params[:week] ? params[:week].to_i : current_week
  end

  def current_week
    Time.new.strftime('%W').to_i + 1
  end
end
