# frozen_string_literal: true

require 'rails_helper'

feature 'User can destroy answer', %q{
  In order to destroy wrong answer
  As an authenticated user
  I'd like to be able to destroy my own answer
} do

  given(:user) { create(:user) }
  given(:question) { create :question, author: user }
  given(:answer) { create_list :answer, 3, question: question, author: user }

  describe 'Authenticated user' do
    background do 
      sign_in(user)
    end

    scenario "can destroy his own answer" do
      question = create :question, author: user
      answer = create :answer, question: question, author: user

      visit question_path(question)

      click_on I18n.t('questions.show.delete_answer')

      expect(page).to have_content I18n.t('answers.destroy.success')
      expect(page).to have_content I18n.t('questions.show.answers')
      expect(page).not_to have_content answer.body
    end

    scenario "can't destroy other's answer" do
      other_user = create :user
      others_question = create :question, author: other_user
      create :answer, question: others_question, author: other_user

      visit question_path(others_question)

      expect(page).not_to have_link I18n.t('questions.show.delete_answer')
      
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't destroy an answer" do
      question = create :question, author: user
      create :answer, question: question, author: user
  
      visit question_path(question)
  
      expect(page).not_to have_content I18n.t('questions.show.delete_answer')
    end
  end
end