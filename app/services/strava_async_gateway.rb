class StravaAsyncGateway
  def initialize(session=StravaSession.new)
    @session = session
  end

  def name(athlete_number)
    url         = "http://app.strava.com/athletes/#{athlete_number}"
    params      = Params.new
    params.cookies << session.cookie
    request     = Typhoeus::Request.new(url, params.to_h)
    response    = request.run
    title       = response.body[/<title>(.*?)<\/title>/, 1]
    name        = title[/\| (.+?)$/, 1]
    first, last = name.split(' ')
    "#{first} #{last.chars.first}."
  end

  def activities(athlete_numbers, interval)
    data  = []
    hydra = Typhoeus::Hydra.hydra

    athlete_numbers.each do |athlete_number|
      activity(athlete_number, interval) do |request|
        request.on_complete do |response|
          if login_redirect?(response)
            session.login
            response = request.run
          end
          data << parse(response)
        end
        hydra.queue(request)
      end
    end

    hydra.run
    data
  end

  def activity(athlete_number, interval)
    url     = "http://app.strava.com/athletes/#{athlete_number}/interval?interval=#{interval}&interval_type=week&chart_type=miles&year_offset=0&_=1371324855824"
    params  = Params.new
    params.cookies << session.cookie
    params.headers.merge({'X-Requested-With' => 'XMLHttpRequest'})
    request = Typhoeus::Request.new(url, params.to_h)
    if block_given?
      yield request
    else
      response = request.run
      parse(response)
    end
  end

  private
  attr_reader :session

  def login_redirect?(response)
    response.response_code == 302
  end

  def parse(response)
    lines    = response.body.lines.to_a
    result   = {
      number: lines[0][/athletes\/(.+?)#/, 1],
      name:   lines[3][/img alt=\\'(.+?)\\'/, 1]
    }
    totals = Nokogiri::HTML(lines[2]).search('li strong')

    if totals && totals[0] && totals[2] then
      result[:distance] = totals[0].children[0].text.to_f
      result[:climb]    = totals[2].children[0].text.sub(',', '').to_i
    else
      result[:distance] = 0.0
      result[:climb]    = 0
    end
    result
  end

  #def headers(cookies='')
    #{
    #'Accept'     => 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript',
    #'User-Agent' => 'mozilla/5.0 (macintosh; intel mac os x 10_6_8) applewebkit/535.19 (khtml, like gecko) chrome/18.0.1025.168 safari/535.19',
    #'Cookie'     => cookies,
    #}
  #end

  #def default_params(cookies='')
    #{
      #:headers        => headers.merge({'Cookie' => cookies}),
      #:followlocation => true,
    #}
  #end

  #def strava_cookie(response)
    #set_cookie = response.headers_hash["Set-Cookie"]
    #cookie_jar = CookieJar.new.parse(set_cookie)
    #"_strava3_session=#{cookie_jar['_strava3_session']}"
  #end
end
