class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :athletes
  embedded_in :user, :inverse_of => :races

  accepts_nested_attributes_for :athletes,
                                :reject_if => lambda { |a| a[:number].blank? }

  field :name, type: String

  validates_presence_of :name
  attr_accessible :name, :athletes
end
