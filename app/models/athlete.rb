class Athlete
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :race

  field :name, type: String
  field :number, type: String

  validates_presence_of :number

  attr_accessible :name, :number
end
