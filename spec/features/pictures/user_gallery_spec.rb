require 'rails_helper'

RSpec.feature 'User pictures gallery', type: :feature do
  let!(:user) { Fabricate(:user) }

  feature 'non logged in user' do
    scenario 'visits gallery page' do
      visit user_pictures_path(user)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text('You need to sign in or sign up before continuing.')
    end
  end

  feature 'logged in user' do
    scenario 'visit gallery from other user' do
      spy = Fabricate(:user, email: 'spy@devapp.com')

      login_as(spy)

      visit user_pictures_path(user)

      expect(page).to have_current_path(root_path)
    end

    feature 'Gallery from current user' do
      before do
        login_as(user)
      end

      scenario 'user has no pictures' do
        visit user_pictures_path(user)

        expect(page.find('#gallery')).to have_text('No pictures yet')
        expect(page.find('.new-pictures')).to have_text('add new picture')
      end

      scenario 'user has pictures' do
        picture = Fabricate(:picture, user: user, title: 'nice picture')
        visit user_pictures_path(user)

        expect(page.find('#gallery')).not_to have_text('No pictures yet')

        # picture content
        expect(page.find('.user-picture img.img-rounded')['src']).to have_content('test.jpg')
        expect(page.find('.user-picture')).to have_text('nice picture')
        expect(page.find('.user-picture')).
          to have_text(picture.created_at.strftime('on %d/%m/%Y'))
      end
    end
  end
end
