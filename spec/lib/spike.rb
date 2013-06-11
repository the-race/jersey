require 'typhoeus'
require 'nokogiri'

module Jersey
  class StravaGatewayAsync

    LOGIN_URL      = 'https://www.strava.com/login'
    LOGIN_POST_URL = 'https://www.strava.com/session'
    COOKIE_FILE    = 'strava-cookie.txt'

    HEADERS = {
      "Accept" => "text/html,text/javascript",
      "Cache-Control" => "no-cache",
      "Pragma" => "no-cache",
      "User-Agent" => "mozilla/5.0 (macintosh; intel mac os x 10_6_8) applewebkit/535.19 (khtml, like gecko) chrome/18.0.1025.168 safari/535.19",
    }

login_req = Typhoeus::Request.new(
  LOGIN_URL,
  method: :get,
  headers: headers,
  followlocation: true,
  cookiefile: COOKIE_FILE,
  cookiejar: COOKIE_FILE
)
login_res = login_req.run

authenticity_token = Nokogiri::HTML(login_res.body).search('input[@name="authenticity_token"]').first['value']

submit_req = Typhoeus::Request.new(
  LOGIN_POST_URL,
  method: :post,
  params: {
    authenticity_token: authenticity_token,
    email: 'laura201shoes@hotmail.com',
    password: '12watch',
    remember_me: 'on'
  },
  headers: headers,
  followlocation: true,
  cookiefile: COOKIE_FILE,
  cookiejar: COOKIE_FILE
)

submit_res = submit_req.run
submit_res.body[/<title>(.*?)<\/title>/, 1]

athlete_number = '421557'
interval = '201322'
activity_url = "http://app.strava.com/athletes/#{athlete_number}/interval?interval=#{interval}&interval_type=week&chart_type=miles&year_offset=0&_=1369352085457"
dash_req = Typhoeus::Request.new( activity_url,
                                  headers: headers,
                                  followlocation: true,
                                  cookiefile: COOKIE_FILE,
                                  cookiejar: COOKIE_FILE
                                 )
dash_res = dash_req.run
#puts dash_res.body
lines = dash_res.body.lines.to_a
lines[1][/Activities for (.+?)\\n/, 1]

  end
end
