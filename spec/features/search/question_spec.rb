# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search questions', "
  In order to find question
  As an authenticated user
  I'd like to be able to find question" do

  given!(:question) { create :question, title: 'question_for_search' }

  scenario 'user can find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      choose 'Question'

      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'user do not find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Question'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content question.title
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'user can search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content question.title
      end
    end
  end
end