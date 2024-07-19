# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search users', "
  In order to find user
  As an authenticated user
  I'd like to be able to find user" do

  given!(:user) { create :user }

  scenario 'user can find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      choose 'User'

      click_on 'Search'

      expect(page).to have_content user.email
    end
  end

  scenario 'user do not find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'User'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content user.email
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'user can search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content user.email
      end
    end
  end
end