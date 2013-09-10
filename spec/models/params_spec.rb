require 'spec_helper_lite'
require 'params'

describe Params do
  it "#to_h" do
    expect(subject.to_h).to eq({:followlocation=>true, :headers=>{"Accept"=>"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript", "User-Agent"=>"mozilla/5.0 (macintosh; intel mac os x 10_6_8) applewebkit/535.19 (khtml, like gecko) chrome/18.0.1025.168 safari/535.19", "Cookie"=>""}})
  end
end
