class StravaSession
  def initialize(email=ENV['STRAVA_EMAIL'], password=ENV['STRAVA_PASSWORD'])
    raise ArgumentError, 'email cannot be blank'    if blank?(email)
    raise ArgumentError, 'password cannot be blank' if blank?(password)
    @email    = email
    @password = password
    @agent    = Mechanize.new
  end

  def cookie
    login unless logged_in?
    @cookie
  end

  def login
    login_page    = @agent.get('https://www.strava.com/login')
    form          = login_page.form_with(action: '/session')
    form.email    = @email
    form.password = @password
    home_page     = @agent.submit(form)
    unless home_page.title =~ /Home/
      raise "Login failed for email #{@email}"
    end
    @cookie = "_strava3_session=#{@agent.cookies.first.value}"
    @status = :logged_in
  end

  def logged_in?
    @status == :logged_in
  end

  private

  def blank?(arg)
    arg.nil? || arg.empty?
  end
end
