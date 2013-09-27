require 'spec_helper'

describe Race do
  let (:attributes) do
    {
      name: 'Tour of Newcastle',
      athletes: [Athlete.new({ number: '1', name: 'Justin R.' })]
    }
  end

  it 'should create a new instance given a valid attribute' do
    Race.create!(attributes)
  end

  it 'should require a name' do
    no_name_race = Race.new(attributes.merge(name: ''))
    no_name_race.should_not be_valid
  end
end
