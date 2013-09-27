GuestUser = Struct.new(:name) do
  def prefers_metric?
    false
  end
end
