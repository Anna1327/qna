# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create :question, author: user }
  given!(:answer) { create_list :answer, 3, question: question, author: user }

  describe 'Authenticated user' do
    background do 
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'Answer body'
    end

    scenario "can create an answer to the question" do
      answers_count = question.answers.count
      click_on I18n.t('answers.create.submit')

      expect(page).to have_content I18n.t('answers.create.success')
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      expect(page).to have_content I18n.t('questions.show.answers')
      expect(page.all('li').count).to eq answers_count + 1
    end
  end

  describe 'Unauthenticated user' do
    background do 
      visit question_path(question)
      fill_in 'Body', with: 'Answer body'
      click_on I18n.t('answers.create.submit')
    end

    scenario "tries to create an answer to the question" do
      expect(page).to have_content 'You need to sign in or sign up before continuing.' 
    end
  end
end