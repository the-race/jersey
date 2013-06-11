class RacesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @race = current_user.races.find(params[:id])
    @race.athletes.all.each do |athlete|
      athlete.name = gateway.name(athlete.number) unless athlete.name
      total = athlete.totals.find_or_initialize_by(year: year, week: week)
      if week == @race.current_week || !total.persisted?
        data  = gateway.activity(athlete.number, period)
        total.populate_with(data)
      end
    end
    @race.save
    @race = RaceDecorator.new(@race, year, week)
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
    "#{year}#{week}"
  end

  def year
    params[:year].to_i || Time.new.year
  end

  def week
    params[:week].to_i || current_week
  end

end
