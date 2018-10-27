require 'rails_helper'

RSpec.feature 'User login', type: :feature do
  let(:email) { 'user@email.com' }
  let(:password) { '123456' }
  let!(:user) { Fabricate(:user, email: email, password: password) }

  scenario 'User logs in' do
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'

    expect(page).to have_current_path(root_path)
    expect(page).to have_text('Signed in successfully.')
  end
end
