require 'rails_helper'

RSpec.feature 'User login', type: :feature do
  scenario 'User registration' do
    visit new_user_registration_path

    fill_in 'Email', with: 'name@devapp.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_current_path(root_path)
    expect(page).to have_text('Welcome! You have signed up successfully.')
  end
end
