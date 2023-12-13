# frozen_string_literal: true

require 'rails_helper'

feature 'User can to mark answer as the best for his question', %q{
  In order to choose best answer for my question
  As an author of question
  I'd like to be able to mark answer as the best
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answers) { create_list :answer, 3, question: question, author: user }
  given(:best_answer) { answers.last }

  describe 'User as the author of question', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'can choose best answer' do
      within ".answers li#answer-#{best_answer.id}" do
        click_on I18n.t('answers.mark_as_the_best.submit')
      end

      visit question_path(question)
      expect(page).to have_selector("#answer-#{best_answer.id}.best_answer")
    end

    scenario 'can choose another best answer' do
      best_answer.set_best_answer(question)
      new_best_answer = answers.first

      within ".answers li#answer-#{new_best_answer.id}" do
        click_on I18n.t('answers.mark_as_the_best.submit')
      end

      visit question_path(question)
      expect(page).to have_selector("#answer-#{new_best_answer.id}.best_answer")
    end

    scenario "best answer on the top" do
      within ".answers li#answer-#{best_answer.id}" do
        click_on I18n.t('answers.mark_as_the_best.submit')
      end

      visit question_path(question)

      expect(page).to have_selector(".answers>li#answer-#{best_answer.id}.best_answer")
    end
  end

  scenario 'User is not the author of question' do
    visit question_path(question)

    within '.answers' do
      expect(page.all('.best-answer-link').count).to eq 0
    end
  end
end