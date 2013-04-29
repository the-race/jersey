class RacesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @race = current_user.new_race
    3.times { @race.athletes.build }
  end
end
