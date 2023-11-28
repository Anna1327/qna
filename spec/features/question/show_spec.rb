# frozen_string_literal: true

require 'rails_helper'

feature 'User can show question', %q{
  In order to get help from a community
  As an user
  I'd like to be able to view the question and answers to it
} do

  given(:user) { create(:user) }
  given!(:question) { create :question, author: user }
  given!(:answer) { create_list :answer, 3, question: question, author: user }

  describe "Authenticated user" do
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario "user can view the question and answers" do
      expect(page).to have_content I18n.t('questions.show.header')
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      expect(page).to have_content I18n.t('questions.show.answers')
      expect(page.all('li').count).to eq(3)
    end
  end

  describe "Unauthenticated user" do
    background do
      visit question_path(question)
    end

    scenario "user can view the question and answers" do
      expect(page).to have_content I18n.t('questions.show.header')
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      expect(page).to have_content I18n.t('questions.show.answers')
      expect(page.all('li').count).to eq(3)
    end
  end
end