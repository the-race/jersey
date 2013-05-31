class Total
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :athlete, :inverse_of => :totals

  field :distance_km,  type: Float
  field :climb_meters, type: Integer
  field :year,         type: Integer
  field :week,         type: Integer

  attr_accessible :distance_km, :climb_meters, :year, :week

  def populate_with(data)
    self.distance_km  = data.fetch(:distance)
    self.climb_meters = data.fetch(:climb)
  end
end
