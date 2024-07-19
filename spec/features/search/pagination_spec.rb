# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can use paginations' do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answers) { create_list(:answer, 22, question: question, author: user) }

  scenario 'can use pagination', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Body'
      choose 'Answer'

      click_on 'Search'

      within '.search-result' do
        expect(page.all('a', text: 'Body of the answer').count).to eq 20

        click_on 'Next'
        expect(page.all('a', text: 'Body of the answer').count).to eq 2

        click_on 'Prev'
        expect(page.all('a', text: 'Body of the answer').count).to eq 20

        expect(page).to_not have_link 'Prev'
        expect(page).to have_link 'Next'
      end
    end
  end
end