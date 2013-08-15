class TotalsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @race = Race.find(params[:id])
    @race.force_update_totals(gateway, interval)
    redirect_to race_path(@race, interval.to_params)
  end

  private

  def gateway
    StravaAsyncGateway.new
  end

  def interval
    Interval.create_from(params)
  end
end
