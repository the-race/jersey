class Athlete
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :totals
  has_and_belongs_to_many :races

  field :number, type: String
  field :name,   type: String

  validates_presence_of :number

  attr_accessible :number, :name

  def has_totals_for?(interval)
    totals.where(interval.to_params).exists?
  end

  def totals_for(interval)
    totals.where(interval.to_params).first
  end

  def fetch_name(gateway)
    unless name
      self.name = gateway.name(number)
    end
  end
end
