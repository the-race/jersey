#require 'spec_helper'

require 'typhoeus'
require 'nokogiri'

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
      response = request.run
      parse(response)
    end

    private
    attr_reader :email, :password

    def login
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

      #puts submit_res.body

      #unless login_page.title =~ /Home/
        #form          = login_page.form_with(action: '/session')
        #form.email    = email
        #form.password = password
        #home_page     = agent.submit(form)
        #unless home_page.title =~ /Home/
          #raise "Login failed for email #{email}"
        #end
        #home_page
      #end
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



  describe StravaAsyncGateway do
    subject { StravaAsyncGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD']) }

    describe '#name' do
      it "gets data from strava for the 1108047" do
        #VCR.use_cassette 'lib/activity201321' do
          subject.name('1108047').should == 'Justin R.'
        #end
      end
    end

    describe '#activity' do
      it "gets data from strava for the 201321" do
        #VCR.use_cassette 'lib/activity201321' do
          data = subject.activity('1108047', '201321')
          data[:number].should == '1108047'
          data[:period].should == 'May 20, 2013 - May 26, 2013'
          data[:name].should == 'Justin Ramel'
          data[:distance].should == 215.3
          data[:climb].should == 1543
        #end
      end
    end
  end

end
