require 'spec_helper'

feature 'sign up' do
  scenario 'new user' do
    visit '/accounts/new'

    fill_in 'account_name', :with => 'Justin'
    fill_in 'account_email', :with => 'jramel@test.com'
    fill_in 'account_password', :with => 'secret'
    fill_in 'account_password_confirmation', :with => 'secret'
    fill_in 'account_athlete_number', :with => 'jramel'

    click_button 'Sign me up'

    expect(page).to have_content('Home')
    expect(page).to have_content('Account was successfully created')
  end
end
