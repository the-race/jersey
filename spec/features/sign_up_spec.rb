require 'spec_helper'

feature 'sign up' do
  scenario 'new user' do
    visit '/accounts/new'

    fill_in 'name', :with => 'Justin'
    fill_in 'email', :with => 'jramel@test.com'
    fill_in 'password', :with => 'secret'
    fill_in 'password_confirmation', :with => 'secret'
    fill_in 'athlete_number', :with => 'jramel'

    click_button 'Sign me up'

    expect(page).to have_content('Home')
    expect(page).to have_content('Account was successfully created')
  end
end