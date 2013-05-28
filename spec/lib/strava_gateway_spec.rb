require 'spec_helper'
require 'jersey/strava_gateway'

module Jersey
  describe StravaGateway do
    subject { StravaGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD']) }

    describe '#activity' do
      it "gets data from strava for the 201321" do
        VCR.use_cassette 'lib/activity201321' do
          data = subject.activity('1108047', '201321')
          data[:number].should == '1108047'
          data[:period].should == 'May 20, 2013 - May 26, 2013'
          data[:name].should == 'Justin Ramel'
          data[:distance].should == 215.3
          data[:climb].should == 1543
        end
      end
    end

    describe '#activities' do
      it "gets multiple data from strava for the 201321" do
        VCR.use_cassette 'lib/activities201321' do
          data = subject.activities(['1108047', '605007'], '201321')
          data.first[:number].should == '1108047'
          data.first[:period].should == 'May 20, 2013 - May 26, 2013'
          data.first[:name].should == 'Justin Ramel'
          data.first[:distance].should == 215.3
          data.first[:climb].should == 1543
          data.last[:number].should == '605007'
          data.last[:period].should == 'May 20, 2013 - May 26, 2013'
          data.last[:name].should == 'Anthony Griffiths'
          data.last[:distance].should == 211.5
          data.last[:climb].should == 2192
        end
      end
    end

    describe '#name' do
      it "gets name given athlete number" do
        VCR.use_cassette 'lib/name' do
          subject.name('1108047').should == 'Justin Ramel'
        end
      end
    end

  end
end
