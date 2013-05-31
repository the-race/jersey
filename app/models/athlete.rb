class Athlete
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :totals
  embedded_in :race, :inverse_of => :athletes

  field :number, type: String
  field :name,   type: String

  validates_presence_of :number

  attr_accessible :number, :name
end
