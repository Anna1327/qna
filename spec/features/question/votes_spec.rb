# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote question', %q{
  In order to rate question
  As an authenticated author
  I'd like to be able to vote other's question
} do

  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    context "is author of question" do
      background do
        question = create :question, author: user
        visit question_path(question)
      end
      scenario "couldn't vote his question" do
        within '.question' do
          expect(page).to have_link('Like', class: 'disabled')
          expect(page).to have_link('Dislike', class: 'disabled')
        end
      end
    end

    context "is not author of question" do
      background do
        visit question_path(question)
      end

      scenario "can liked question" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
        end
      end

      scenario "can disliked question" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
        end
      end

      scenario "can cancel liked question" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '0'
        end
      end

      scenario "can cancel disliked question" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
          click_on 'Like'
          expect(page.find('.count')).to have_content '0'
        end
      end

      scenario "can't liked question twice" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
        end
      end

      scenario "can't disliked question twice" do
        within '.question' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
        end
      end
    end
  end

  describe "Unauthenticated user", js: true do
    background do
      visit question_path(question)
    end
    scenario "couldn't vote question" do
      within '.question' do
        expect(page).to have_link('Like', class: 'disabled')
        expect(page).to have_link('Dislike', class: 'disabled')
      end
    end
  end
end