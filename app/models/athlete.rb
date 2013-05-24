class Athlete
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :race, :inverse_of => :athletes

  field :number, type: String

  validates_presence_of :number

  attr_accessible :number
end
