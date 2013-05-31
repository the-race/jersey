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

  #def period
    #data_by_distance.first[:period]
  #end

  #def activities(year, week, data)
    #@year = year.to_i
    #@week = week.to_i
    #@data = data
    #update_names
    #convert_km_to_miles
    #convert_meters_to_feet
  #end

  def last_week
    @week - 1
  end

  def last_year
    @year
  end

  def next_week
    @week + 1
  end

  def next_year
    @year
  end

  #def update_names
    #@data.each {|d| d[:name] = athletes.select {|a| a.number == d[:number]}.first.name}
  #end

  #def convert_km_to_miles
    #@data.each {|d| d[:distance] = d[:distance] * 0.621371192237334}
  #end

  #def convert_meters_to_feet
    #@data.each {|d| d[:climb] = d[:climb] * 3.2808}
  #end

end
