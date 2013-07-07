class HomeController < ApplicationController
  def index
    @races = Race.all
  end
end
