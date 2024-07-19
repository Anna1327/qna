# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment question', "
  In order to discuss question
  As an authenticated user
  I'd like to be able to comment question
" do
  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }

  describe 'multiple sessions', js: true do
    scenario "comment appears on other's user page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Comment body', with: 'Body of the comment'
          click_on 'Add comment'
          expect(page).to have_content 'Body of the comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'Body of the comment'
        end
      end
    end
  end
end
