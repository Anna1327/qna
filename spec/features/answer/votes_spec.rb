# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for answer', %q{
  In order to rate answer
  As an authenticated author
  I'd like to be able to vote other's answer
} do

  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }
  given!(:answer) { create :answer, question: question, author: other_user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    context "is author of answer" do
      background do
        question = create :question, author: user
        create :answer, question: question, author: user

        visit question_path(question)
      end
      scenario "can't vote for his own answer" do
        within '.answers' do
          expect(page).to have_link('Like', class: 'disabled')
          expect(page).to have_link('Dislike', class: 'disabled')
        end
      end
    end

    context "is not author of answer" do
      background do
        visit question_path(question)
      end

      scenario "can liked answer" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
        end
      end

      scenario "can disliked question" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
        end
      end

      scenario "can to cancel like of answer" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '0'
        end
      end

      scenario "can to cancel dislike of answer" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
          click_on 'Like'
          expect(page.find('.count')).to have_content '0'
        end
      end

      scenario "can't liked answer twice" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Like'
          click_on 'Like'
          expect(page.find('.count')).to have_content '1'
        end
      end

      scenario "can't disliked answer twice" do
        within '.answers' do
          expect(page.find('.count')).to have_content '0'
          click_on 'Dislike'
          click_on 'Dislike'
          expect(page.find('.count')).to have_content '-1'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      question = create :question, author: user
      create :answer, question: question, author: user

      visit question_path(question)
    end
    scenario "couldn't vote answer" do
      within '.answers' do
        expect(page).to have_link('Like', class: 'disabled')
          expect(page).to have_link('Dislike', class: 'disabled')
      end
    end
  end
end