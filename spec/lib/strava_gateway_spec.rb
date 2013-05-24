require 'spec_helper'
require 'strava_gateway'

module Jersey
  describe StravaGateway do
    subject { StravaGateway.new(ENV['STRAVA_EMAIL'], ENV['STRAVA_PASSWORD']) }

    describe '#activities' do
      it "gets data from strava for the 201321" do
        VCR.use_cassette 'lib/strava201321' do
          data = subject.activities('1108047', '201321')
          data[:id].should == '1108047'
          data[:period].should == 'May 20, 2013 - May 26, 2013'
          data[:name].should == 'Justin Ramel'
          data[:distance].should == '215.3'
          data[:climb].should == '1543'
        end
      end

      it "gets data from strava for the 201320" do
        VCR.use_cassette 'lib/strava201320' do
          data = subject.activities('1108047', '201320')
          data[:id].should == '1108047'
          data[:period].should == 'May 13, 2013 - May 19, 2013'
          data[:name].should == 'Justin Ramel'
          data[:distance].should == '307.7'
          data[:climb].should == '3067'
        end
      end
    end
  end
end
