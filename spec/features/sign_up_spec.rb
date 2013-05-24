require 'spec_helper'

feature 'sign up' do
  scenario 'new user' do
    visit '/users/sign_up'

    fill_in 'user_name', :with => 'Justin'
    fill_in 'user_email', :with => 'jramel@test.com'
    fill_in 'user_password', :with => 'secretsh'
    fill_in 'user_password_confirmation', :with => 'secretsh'
    fill_in 'user_athlete_number', :with => 'jramel'

    click_button 'Sign up'

    expect(page).to have_content('Dashboard')
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
