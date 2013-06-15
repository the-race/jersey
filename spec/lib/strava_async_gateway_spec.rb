require 'rubygems'
require 'typhoeus'
require 'nokogiri'
require 'vcr'
require 'strava_async_gateway'

module Jersey
  describe StravaAsyncGateway do
    subject { StravaAsyncGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD']) }

    describe '#name' do
      it "gets data from strava for the 1108047" do
        #VCR.use_cassette 'lib/activity201321' do
          subject.name('1108047').should == 'Justin R.'
        #end
      end
    end

    #describe '#activity' do
      #it "gets data from strava for the 201321" do
        #VCR.use_cassette 'lib/activity201321' do
          #data = subject.activity('1108047', '201321')
          #data[:number].should == '1108047'
          #data[:period].should == 'May 20, 2013 - May 26, 2013'
          #data[:name].should == 'Justin Ramel'
          #data[:distance].should == 215.3
          #data[:climb].should == 1543
        #end
      #end
    #end

    describe '#activities' do
      it "gets multiple data from strava for the 201321" do
        #VCR.use_cassette 'lib/activities201321' do
          data = subject.activities(['1108047', '605007'], '201321')
          if data.first[:number] == '1108047'
            justin, anthony = data.first, data.last
          else
            justin, anthony = data.last, data.first
          end

          justin[:number].should == '1108047'
          justin[:period].should == 'May 20, 2013 - May 26, 2013'
          justin[:name].should == 'Justin Ramel'
          justin[:distance].should == 215.3
          justin[:climb].should == 1543

          anthony[:number].should == '605007'
          anthony[:period].should == 'May 20, 2013 - May 26, 2013'
          anthony[:name].should == 'Anthony Griffiths'
          anthony[:distance].should == 211.5
          anthony[:climb].should == 2192
        #end
      end
    end
  end
end
