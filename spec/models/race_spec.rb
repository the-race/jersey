require 'spec_helper'

describe Race do

  let (:user) {
    User.create!({
      :name => "Example User",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    })
  }

  let (:attr) do
    {
      :name => "Tour of Newcastle",
      :athletes => [ {:name => "Justin R."} ]
    }
  end

  it "should create a new instance given a valid attribute" do
    user.races.create!(attr)
  end

  it "should require a name" do
    no_name_race = Race.new(attr.merge(:name => ""))
    no_name_race.should_not be_valid
  end

end
