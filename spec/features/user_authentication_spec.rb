require 'spec_helper'

feature 'User authentication' do
  scenario 'guest user trying to access dashboard page' do
    visit '/dashboard'

    expect(page).to have_content('Login')
  end

  scenario 'successful login' do
    user = Fabricate(:user)
    visit '/users/sign_in'

    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => user.password

    click_button 'Sign in'

    expect(page).to have_content('Dashboard')
  end

  scenario 'failed login' do
    user = Fabricate(:user)
    visit '/users/sign_in'

    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => 'wrong_password'

    click_button 'Sign in'

    expect(page).to have_content('Invalid email or password')
  end
end
