require 'mechanize'

module Jersey
  class StravaGateway
    LOGIN_URL = 'https://www.strava.com/login'
    TOTALS    = 2
    DISTANCE  = 0
    FEET      = 2

    def initialize(email, password)
      @email    = email
      @password = password
      @agent    = Mechanize.new
    end

    def activities(athlete_id, interval)
      activity_url  = "http://app.strava.com/athletes/#{athlete_id}/interval?interval=#{interval}&interval_type=week&chart_type=miles&year_offset=0&_=1369352085457"

      home_page = login
      unless home_page.title =~ /Home/
        raise "Login failed for email #{email}"
      end
      activity_page = agent.get(activity_url)
      #require 'pry'; binding.pry
      parse(activity_page)
    end

    private
    attr_reader :agent, :email, :password

    def login
      login_page    = agent.get(LOGIN_URL)
      form          = login_page.form_with(action: '/session')
      form.email    = email
      form.password = password
      agent.submit(form)
    end

    def parse(page)
      lines    = page.body.lines.to_a
      totals   = Nokogiri::HTML(lines[2]).search('li strong')
      distance = totals[0].children[0].text
      climb    = totals[2].children[0].text.sub(',', '')
      {
        id:       page.uri.to_s[/\d+/],
        period:   lines[1][/Activities for (.+?)\\n/, 1],
        name:     lines[3][/img alt=\\'(.+?)\\'/, 1],
        distance: distance,
        climb:    climb
      }
    end
  end
end
