# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'ask a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'with multiple sessions', js: true do
    background do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end
    end

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        refresh
        expect(page).to have_content 'Test question'
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to ask question' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
