require 'rubygems'
require 'mechanize'

module Jersey
  class StravaGateway
    LOGIN_URL = 'https://www.strava.com/login'

    def initialize(email, password)
      @email    = email
      @password = password
      @agent    = Mechanize.new
    end

    def name(athlete_number)
      login
      athlete_page = agent.get("http://app.strava.com/athletes/#{athlete_number}")
      athlete_page.title.split(" | ")[1]
    end

    def activity(athlete_number, interval)
      login
      activity_url  = "http://app.strava.com/athletes/#{athlete_number}/interval?interval=#{interval}&interval_type=week&chart_type=miles&year_offset=0&_=1369352085457"
      activity_page = agent.get(activity_url)
      parse(activity_page)
    end

    def activities(athlete_numbers, interval)
      athlete_numbers.map {|number| activity(number, interval)}
    end

    private
    attr_reader :agent, :email, :password

    def login
      login_page = agent.get(LOGIN_URL)
      if login_page.title =~ /Home/
        login_page
      else
        form          = login_page.form_with(action: '/session')
        form.email    = email
        form.password = password
        home_page = agent.submit(form)
        unless home_page.title =~ /Home/
          raise "Login failed for email #{email}"
        end
        home_page
      end
    end

    def parse(page)
      lines    = page.body.lines.to_a
      totals   = Nokogiri::HTML(lines[2]).search('li strong')
      {
        number:       page.uri.to_s[/\d+/],
        period:   lines[1][/Activities for (.+?)\\n/, 1],
        name:     lines[3][/img alt=\\'(.+?)\\'/, 1],
        distance: totals[0].children[0].text.to_f,
        climb:    totals[2].children[0].text.sub(',', '').to_i
      }
    end
  end
end
