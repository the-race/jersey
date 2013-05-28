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

  def athlete_numbers
    athletes.map {|athlete| athlete.number}
  end

  def period
    data_by_distance.first[:period]
  end

  def names_by_distance
    data_by_distance.map {|d| d[:name]}
  end

  def names_by_climb
    data_by_climb.map {|d| d[:name]}
  end

  def distance
    data_by_distance.map do |a|
      "{y: #{'%.1f' % a[:distance]}, url: 'http://app.strava.com/athletes/#{a[:number]}'}"
    end.to_s.gsub('"', '')
  end

  def climb
    data_by_climb.map do |a|
      "{y: #{'%.0f' % a[:climb]}, url: 'http://app.strava.com/athletes/#{a[:number]}'}"
    end.to_s.gsub('"', '')
  end

  def activities(data)
    @data = data
    update_names
    convert_km_to_miles
    convert_meters_to_feet
  end

  private
  def data_by_distance
    @data.sort_by{|x| -x[:distance]}
  end

  def data_by_climb
    data_by_distance.sort_by {|x| -x[:climb]}
  end

  def update_names
    @data.each {|d| d[:name] = athletes.select {|a| a.number == d[:number]}.first.name}
  end

  def convert_km_to_miles
    @data.each {|d| d[:distance] = d[:distance] * 0.621371192237334}
  end

  def convert_meters_to_feet
    @data.each {|d| d[:climb] = d[:climb] * 3.2808}
  end

end
