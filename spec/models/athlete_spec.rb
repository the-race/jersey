require 'spec_helper'

describe Athlete do

  let (:user) {
    User.create!({
      :name => "Example User",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme",
    })
  }

  let (:race) { user.races.create!({:name => "Tour of Newcastle"}) }

  it "should create a new instance given a valid attribute" do
    race.athletes.create!({:name => "Justin R."})
  end

  it "should require a name" do
    no_name = Athlete.new(:name => "")
    no_name.should_not be_valid
  end

end
