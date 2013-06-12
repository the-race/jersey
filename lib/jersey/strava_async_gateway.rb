module Jersey
  class StravaAsyncGateway
    LOGIN_URL      = 'https://www.strava.com/login'
    LOGIN_POST_URL = 'https://www.strava.com/session'
    COOKIE_FILE    = 'strava-cookie.txt'

    HEADERS = {
      'Accept'        => 'text/html,text/javascript',
      'Cache-Control' => 'no-cache',
      'Pragma'        => 'no-cache',
      'User-Agent'    => 'mozilla/5.0 (macintosh; intel mac os x 10_6_8) applewebkit/535.19 (khtml, like gecko) chrome/18.0.1025.168 safari/535.19',
    }

    DEFAULT_PARAMS = {
      headers:        HEADERS,
      cookiefile:     COOKIE_FILE,
      cookiejar:      COOKIE_FILE,
      followlocation: true,
    }

    def initialize(email, password)
      @email    = email
      @password = password
    end

    def name(athlete_number)
      login
      url      = "http://app.strava.com/athletes/#{athlete_number}"
      request  = Typhoeus::Request.new(url, DEFAULT_PARAMS)
      response = request.run
      title    = response.body[/<title>(.*?)<\/title>/, 1]
      name     = title.split(' | ')[1]
      splits   = name.split(' ')
      first    = splits[0]
      initial  = splits[1].chars.to_a[0]
      "#{first} #{initial}."
    end

    def activity(athlete_number, interval)
      login
      url      = "http://app.strava.com/athletes/#{athlete_number}/interval?interval=#{interval}&interval_type=week&chart_type=miles&year_offset=0&_=1369352085457"
      request  = Typhoeus::Request.new(url, DEFAULT_PARAMS)
      if block_given?
        yield request
      else
        response = request.run
        parse(response)
      end
    end

    def activities(athlete_numbers, interval)
      login

      athletes = []
      hydra    = Typhoeus::Hydra.new(:max_concurrency => 5)

      athlete_numbers.each do |athlete_number|
        activity(athlete_number, interval) do |request|
          request.on_complete do |response|
            athletes << parse(response)
          end
          hydra.queue(request)
        end
      end

      hydra.run
      athletes
    end

    private
    attr_reader :email, :password

    def login
      url      = 'http://app.strava.com/dashboard'
      request  = Typhoeus::Request.new(url, DEFAULT_PARAMS)
      response = request.run
      title    = response.body[/<title>(.*?)<\/title>/, 1]
      return if title =~ /Home/

      request  = Typhoeus::Request.new(LOGIN_URL, DEFAULT_PARAMS)
      response = request.run
      html     = Nokogiri::HTML(response.body)
      token    = html.search('input[@name="authenticity_token"]').first['value']
      params   = {
        method: :post,
        params: {
          authenticity_token: token,
          email: email,
          password: password,
          remember_me: 'on'
        }
      }.merge(DEFAULT_PARAMS)

      request  = Typhoeus::Request.new(LOGIN_POST_URL, params)
      response = request.run
      if response.body.include?('error message simple')
        puts 'login error!'
      else
        puts 'login success'
      end
    end

    def parse(response)
      lines    = response.body.lines.to_a
      totals   = Nokogiri::HTML(lines[2]).search('li strong')
      {
        number:   lines[0][/athletes\/(.+?)#/, 1],
        period:   lines[1][/Activities for (.+?)\\n/, 1],
        name:     lines[3][/img alt=\\'(.+?)\\'/, 1],
        distance: totals[0].children[0].text.to_f,
        climb:    totals[2].children[0].text.sub(',', '').to_i
      }
    end
  end
end
