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
    race.athletes.create!({:number => "123", :name => "Justin R."})
  end

  it "should require a number" do
    no_number = Athlete.new(:number => "")
    no_number.should_not be_valid
  end

end
