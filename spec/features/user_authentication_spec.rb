require 'spec_helper'

feature 'User authentication' do
  scenario 'guest user trying to access home page' do
    visit '/home'
    # save_and_open_page
    expect(page).to have_content('Login')
  end

  scenario 'successful login' do
    visit '/sessions/new'
    
    fill_in 'email', :with => "anthony.griff@gmail.com"
    fill_in 'password', :with => "secret"

    click_button 'Sign in'

    expect(page).to have_content('Home')
  end

end
