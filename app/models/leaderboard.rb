Leaderboard = Struct.new(:name, :total, :behind) do
  def total_to_s
   pretty_float(total)
  end

  def behind_to_s
   behind == '-' ? behind : pretty_float(behind)
  end

  private

  def pretty_float(st)
    ('%.2f' % st).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end
end
