class TotalsController < ApplicationController
  def update
    @race = Race.find(params[:id])
    @race.force_update_totals(gateway, interval)
    flash[:notice] = "Totals updated for #{interval.to_pretty_s}"
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
