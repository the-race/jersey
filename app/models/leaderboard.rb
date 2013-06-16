Leaderboard = Struct.new(:name, :total, :behind) do
  FLOAT_FORMAT = '%.2f'

  def total_to_s
   FLOAT_FORMAT % total
  end

  def behind_to_s
   behind == '-' ? behind : FLOAT_FORMAT % behind
  end
end
