# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search answers', "
  In order to find answer
  As an authenticated user
  I'd like to be able to find answer" do
  given!(:question) { create :question }
  given!(:user) { create :user }
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'user can find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      choose 'Answer'

      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end

  scenario 'user do not find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Answer'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'user can search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content answer.body
      end
    end
  end
end
