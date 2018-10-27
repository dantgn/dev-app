require 'rails_helper'

RSpec.feature 'add new picture', type: :feature do
  let!(:user) { Fabricate(:user) }

  before do
    login_as(user)
  end

  scenario 'add new picture to gallery' do
    visit new_user_picture_path(user)

    fill_in 'Title', with: 'Awesome picture!'
    page.attach_file('Image', Rails.root + 'spec/support/files/test.jpg')
    click_button 'Save'

    expect(page).to have_current_path(user_pictures_path(user))
    expect(page).to have_text('Picture successfully created')
    expect(page.find('.user-picture img.img-rounded')['src']).to have_content('test.jpg')
    expect(page.find('.user-picture')).to have_text('Awesome picture!')
  end
end
