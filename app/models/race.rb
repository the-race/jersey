class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :athletes
  embedded_in :artist
  accepts_nested_attributes_for :athletes

  field :name, type: String

  validates_presence_of :name
end
