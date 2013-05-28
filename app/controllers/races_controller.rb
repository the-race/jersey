class RacesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @race = current_user.races.find(params[:id])
    @race.athletes.each do |athlete|
      athlete.name = gateway.name(athlete.number) unless (athlete.name)
    end
    @race.save
    data  = gateway.activities(@race.athlete_numbers, period)
    @race.activities(data)
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
    Jersey::StravaGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD'])
  end

  def period
    year + week
  end

  def year
    params[:year] || Time.new.year
  end

  def week
    params[:week] || current_week
  end

  def current_week
    Time.new.strftime('%W').to_i + 1
  end

end
