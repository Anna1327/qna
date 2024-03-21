# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment answer', "
  In order to discuss answer
  As an authenticated user
  I'd like to be able to comment answer
" do
  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }
  given!(:answer) { create :answer, question: question, author: user }

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
        within "#answer_#{answer.id}_comments" do
          fill_in "Comment body", with: "Body of the comment"
          click_on "Add comment"
          expect(page).to have_content "Body of the comment"
        end
      end

      Capybara.using_session('guest') do
        within "#answer_#{answer.id}_comments" do
          expect(page).to have_content "Body of the comment"
        end
      end
    end
  end
end