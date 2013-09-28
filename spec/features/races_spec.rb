require 'spec_helper'

feature 'Show a race' do
  before do
    Fabricate(:race)
    visit '/races/tour-de-france'
  end

  scenario 'accessing race page' do
    expect(page).to have_content 'Tour de France'
    expect(page).to have_content 'Leaderboard (Miles)'
  end

  scenario 'updating totals' do
    click_link 'Update now'

    expect(page).to have_content 'Totals updated'
  end
end
