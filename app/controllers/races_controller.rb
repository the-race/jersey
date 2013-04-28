class RacesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @race = current_user.new_race
    @race.athletes.new
    @race.athletes.new
    @race.athletes.build
  end
end
