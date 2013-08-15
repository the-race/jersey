Interval = Struct.new(:year, :week) do
  def current
    Interval.current
  end

  def current_week?
    self == current
  end

  def next
    next_year = year
    next_week = week + 1
    if next_week == 53
      next_year += 1
      next_week  = 1
    end
    Interval.new(next_year, next_week)
  end

  def previous
    prev_year = year
    prev_week = week - 1
    if prev_week == 0
      prev_year -= 1
      prev_week  = 52
    end
    Interval.new(prev_year, prev_week)
  end

  def to_params
    {year: year, week: week}
  end

  def to_s
    "#{year}#{"%02d" % week}"
  end

  def self.create_from(params)
    year = params[:year] ? params[:year].to_i : Interval.current_year
    week = params[:week] ? params[:week].to_i : Interval.current_week
    Interval.new(year, week)
  end

  def self.current
    Interval.new(self.current_year, self.current_week)
  end

  def self.current_year
    Time.new.year
  end

  def self.current_week
    Time.new.strftime('%W').to_i + 1
  end

end
