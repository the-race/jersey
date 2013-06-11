class RaceDecorator < Draper::Decorator
  decorates :race

  attr_reader :year, :week

  def initialize(object, year, week)
    super(object)
    @year, @week = year, week
  end

  delegate :name

  def athlete_numbers
    model.map {|athlete| athlete.number}
  end

  def period
    "fetch this from period table by period"
  end

  def athlete_count
    model.athletes.count
  end

  def previous_link
    prev_year = year
    prev_week = week - 1
    if prev_week == 0
      prev_year -= 1
      prev_week  = 52
    end
    prev_week = "%02d" % prev_week
    h.link_to 'Last week', h.race_path(model, year: prev_year, week: prev_week)
  end

  def next_link
    next_year = year
    next_week = week + 1
    if next_week == 53
      next_year += 1
      next_week  = 1
    end
    next_week = "%02d" % next_week
    h.link_to 'Next week', h.race_path(model, year: next_year, week: next_week)
  end

  def this_week_link
    unless week == model.current_week
      h.link_to '| Current race', h.race_path(model, year: year, week: model.current_week)
    end
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
