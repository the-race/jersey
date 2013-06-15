Interval = Struct.new(:year, :week) do
  def current_week
    Time.new.strftime('%W').to_i + 1
  end

  def current_week?
    week == current_week
  end

  def to_params
    {year: year, week: week}
  end

  def to_s
    "#{year}#{week}"
  end
end
