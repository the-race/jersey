class RaceDecorator < Draper::Decorator

  attr_reader :year, :week

  def initialize(object, year, week)
    super(object)
    @year, @week = year, week
  end

  def name
    model.name
  end

  def athlete_numbers
    model.map {|athlete| athlete.number}
  end

  def period
    "fetch this from period table by period"
  end

  def athlete_count
    model.athletes.count
  end

############ duplication much?
  def names_by_distance
    totals_by_distance.map {|t| t.athlete.name}
  end

  def names_by_climb
    totals_by_climb.map {|t| t.athlete.name}
  end

  def distance
    totals_by_distance.map do |t|
      "{y: #{'%.1f' % (t.distance_km || 0)}, url: 'http://app.strava.com/athletes/#{t.athlete.number}'}"
    end.to_s.gsub('"', '')
  end

  def climb
    totals_by_climb.map do |t|
      "{y: #{'%.1f' % (t.climb_meters || 0)}, url: 'http://app.strava.com/athletes/#{t.athlete.number}'}"
    end.to_s.gsub('"', '')
  end
############# encapsulate what varies?

  def totals_by_distance
    model.athletes.all.map {|a| a.totals.where(year: year, week: week).first}
                           .sort {|x, y| y.distance_km <=> x.distance_km }
  end

  def totals_by_climb
    totals_by_distance.sort {|x, y| y.climb_meters <=> x.climb_meters }
  end

end
