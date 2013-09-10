class RacesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def show
    @race = Race.find(params[:id])
    @race.check_and_update_totals(gateway, interval)
    @race = RaceDecorator.new(@race, interval, current_user)
  end

  def new
    @race = current_user.new_race
  end

  def create
    @race = current_user.create_race(params[:race])
    @race.athletes_attributes = params[:race][:athletes_attributes]
    if @race.save
      redirect_to dashboard_path, :notice => "Race created."
    else
      redirect_to new_race_path, :alert => "Unable to create race."
    end
  end

  def edit
    @race = current_user.find_race(params[:id])
  end

  def update
    @race = current_user.find_race(params[:id])
    @race.athletes.clear

    params[:race][:athletes_attributes].values.each do |a|
      athlete_number = a['number']
      athlete = Athlete.find_or_create_by(number: athlete_number)
      athlete.fetch_name(gateway)
      @race.athletes << athlete
    end

    if @race.save
      redirect_to dashboard_path, :notice => "Race updated."
    else
      redirect_to new_race_path, :alert => "Unable to update race."
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
