require 'spec_helper'

feature 'User authentication' do
  scenario 'guest user trying to access home page' do
    visit '/home'
    # save_and_open_page
    expect(page).to have_content('Login')
  end
end
