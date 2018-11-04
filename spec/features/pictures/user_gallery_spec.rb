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

        expect(find('#gallery')).to have_text('No pictures yet')
        expect(find('.new-pictures')).to have_text('add new picture')
      end

      scenario 'user has pictures' do
        picture1 = Fabricate(:picture, user: user, title: 'nice picture')

        visit user_pictures_path(user)

        expect(find('#gallery')).not_to have_text('No pictures yet')

        # picture content
        expect(find('.user-picture img.img-rounded')['src']).to have_content(picture1.image.url(:thumb))
        expect(find('.user-picture')).to have_text('nice picture')
        expect(find('.user-picture')).
          to have_text(picture1.created_at.strftime('on %d/%m/%Y'))
      end

      feature 'lightbox' do
        let!(:picture1) { Fabricate(:picture, user: user, title: 'nice picture') }
        let!(:image2) { File.open('spec/support/files/football.jpeg') }
        let!(:picture2) do
          Fabricate(:picture, image: image2, user: user, title: 'football!')
        end

        before do
          visit user_pictures_path(user)
        end

        scenario 'click thumbnail to enlarge picture' do
          page.should have_selector('#lightbox', visible: false)

          first('.user-picture').click

          page.should have_selector('#lightbox', visible: true)

          expect(find('#lightbox img.lb-image')['src']).to have_content(picture1.image.url)

          find('#lightbox .lb-close').click

          page.should have_selector('#lightbox', visible: false)
        end

        feature 'navigation' do
          scenario 'navigate through different pictures' do
            first('.user-picture').click

            page.should have_selector('#lightbox', visible: true)

            expect(find('#lightbox img.lb-image')['src']).to have_content(picture1.image.url)
            expect(find('#lightbox .lb-caption')).to have_content(picture1.title)
            expect(find('#lightbox .lb-number')).to have_content('Image 1 of 2')

            find('#lightbox').hover
            find('#lightbox .lb-next').click

            expect(find('#lightbox img.lb-image')['src']).to have_content(picture2.image.url)
            expect(find('#lightbox .lb-caption')).to have_content(picture2.title)
            expect(find('#lightbox .lb-number')).to have_content('Image 2 of 2')

            find('#lightbox .lb-close').click

            page.should have_selector('#lightbox', visible: false)
          end
        end
      end
    end
  end
end
