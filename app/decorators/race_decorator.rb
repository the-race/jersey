class RaceDecorator < Draper::Decorator
  decorates :race

  attr_reader :interval, :user

  def initialize(object, interval, user)
    super(object)
    @interval = interval
    @user     = user
  end

  delegate :name

  def athlete_numbers
    model.map {|athlete| athlete.number}
  end

  def interval_pretty
    date_format = '%d %b, %Y'
    start_date  = Date.commercial(interval.year, interval.week)
    end_date    = start_date + 6
    "#{start_date.strftime(date_format)} - #{end_date.strftime(date_format)}"
  end

  def athlete_count
    model.athletes.count
  end

  def previous_link
    params = interval.previous.to_params
    h.content_tag(:li, h.link_to('<i class="icon-arrow-left"></i>'.html_safe, h.race_path(model, params)))
  end

  def next_link
    attributes = {}
    attributes[:class] = 'disabled' if interval.current_week?
    next_interval = interval.next
    if next_interval.current_week?
      race_path = h.race_path(model)
    else
      race_path = h.race_path(model, next_interval.to_params)
    end

    h.content_tag(:li, h.link_to('<i class="icon-arrow-right"></i>'.html_safe, race_path), attributes)
  end

  def this_week_link
    attributes = {}
    attributes[:class] = 'active' if interval.current_week?
    h.content_tag(:li, h.link_to('<i class="icon-home"></i>'.html_safe, h.race_path(model)), attributes)
  end

  def update_link
    h.link_to('<i class="icon-refresh"></i> Update now'.html_safe, h.total_path(model, interval.to_params), :method=> :put)
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
      "{y: #{'%.2f' % (t.distance(user) || 0)}, url: 'http://app.strava.com/athletes/#{t.athlete.number}'}"
    end.to_s.gsub('"', '')
  end

  def climb
    totals_by_climb.map do |t|
      "{y: #{'%.2f' % (t.climb(user) || 0)}, url: 'http://app.strava.com/athletes/#{t.athlete.number}'}"
    end.to_s.gsub('"', '')
  end
############# encapsulate what varies?

  def distance_units
    user.prefers_metric? ? 'Km' : 'Miles'
  end

  def climb_units
    user.prefers_metric? ? 'Meters' : 'Feet'
  end

  def totals_by_distance
    model.athletes.map {|a| a.totals_for(interval)}
                       .sort {|x, y| y.distance(user) <=> x.distance(user)}
  end

  def totals_by_climb
    totals_by_distance.sort {|x, y| y.climb(user) <=> x.climb(user)}
  end

  def leaderboard_by_distance
    leaderboard = model.athletes.map {|a| create(a, a.totals_for(interval).distance(user))}
    populate_and_sort(leaderboard)
  end

  def leaderboard_by_climb
    board = model.athletes.map {|a| create(a, a.totals_for(interval).climb(user))}
    populate_and_sort(board)
  end

  def rank(index, total)
    number = index + 1
    if (1..3).include?(number) && total > 0
      h.image_tag("rank-#{number}.png")
    else
      number
    end
  end

  private
  def create(athlete, total)
    Leaderboard.new(athlete.name, total, '-')
  end

  def populate_and_sort(leaderboard)
    leader, *rest = leaderboard.sort! {|x, y| y.total <=> x.total}
    rest.each {|a| a.behind = leader.total - a.total}
    leaderboard
  end
end
