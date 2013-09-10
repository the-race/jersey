class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  has_and_belongs_to_many :athletes
  belongs_to :user, :inverse_of => :races

  accepts_nested_attributes_for :athletes,
                                :reject_if => lambda { |a| a[:number].blank? }

  field :name, type: String
  slug  :name

  validates_presence_of   :name
  validates_uniqueness_of :name
  attr_accessible :name, :athletes

  def check_and_update_totals(gateway, interval)
    to_update = athletes_to_update(interval)
    unless to_update.empty?
      update_totals(to_update, gateway, interval)
    end
  end

  def force_update_totals(gateway, interval)
    update_totals(athletes, gateway, interval)
  end

  private

  def update_totals(to_update, gateway, interval)
    athlete_numbers = to_update.map {|a| a.number}
    totals = gateway.activities(athlete_numbers, interval)
    totals.each do |data|
      athlete = to_update.select {|a| a.number == data[:number]}.first
      athlete.fetch_name(gateway)
      total = athlete.totals.find_or_initialize_by(interval.to_params)
      total.populate_with(data)
    end
    save end

  def athletes_to_update(interval)
    return athletes if interval.current_week?
    athletes.select {|a| !a.has_totals_for?(interval)}
  end
end
