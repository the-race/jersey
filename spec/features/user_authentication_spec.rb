require 'spec_helper'

feature 'User authentication' do
  scenario 'guest user trying to access home page' do
    visit '/home'
    # save_and_open_page
    expect(page).to have_content('Login')
  end

  scenario 'successful login' do
    visit '/sessions/new'

    fill_in 'email', :with => "test@test.com"
    fill_in 'password', :with => "password"

    click_button 'Sign in'

    expect(page).to have_content('Home')
  end

end
