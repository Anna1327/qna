# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search comments', "
  In order to find comment
  As an authenticated user
  I'd like to be able to find comment" do
  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:comment) { create :comment, commentable: question, body: 'test_comment_text' }

  scenario 'user can find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment.body
      choose 'Comment'

      click_on 'Search'

      expect(page).to have_content comment.body
    end
  end

  scenario 'user do not find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Comment'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content comment.body
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'user can search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment.body
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content comment.body
      end
    end
  end
end
