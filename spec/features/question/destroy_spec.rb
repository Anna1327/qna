# frozen_string_literal: true

require 'rails_helper'

feature 'User can destroy his question', "
  In order to destroy wrong question which I created
  As an authenticated user
  I'd like to be able to destroy my own question
" do
  given(:user) { create(:user) }
  given!(:question) { create :question, author: user }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can to destroy his own question' do
      visit question_path(question)

      click_on I18n.t('questions.show.delete')

      expect(page).not_to have_content question.title
    end

    scenario "can not to destroy other's question" do
      other_user = create :user
      others_question = create :question, author: other_user

      visit question_path(others_question)
      expect(page).not_to have_content I18n.t('questions.show.delete')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not to destroy question' do
      visit question_path(question)
      expect(page).not_to have_content I18n.t('questions.show.delete')
    end
  end
end
