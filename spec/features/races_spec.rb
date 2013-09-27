require 'spec_helper'

feature 'Races' do
  scenario 'guest user accessing race page' do
    Fabricate(:race)

    visit '/races/tour-de-france'

    expect(page).to have_content 'Tour de France'
    expect(page).not_to have_content('something went wrong')
  end
end
