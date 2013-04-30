class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :athletes
  embedded_in :artist

  accepts_nested_attributes_for :athletes, :allow_destroy => true

  field :name, type: String

  validates_presence_of :name
  attr_accessible :name, :athletes
end
