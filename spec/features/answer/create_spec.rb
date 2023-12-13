# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create :question, author: user }
  given(:answers) { create_list :answer, 3, question: question, author: user }

  describe 'Authenticated user', js: true do
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario "can create an answer to the question" do
      fill_in 'answer_body', with: 'Answer body'
      click_on I18n.t('answers.create.submit')
      
      expect(page).to have_content I18n.t('questions.show.answers')
      within '.answers' do
        expect(page).to have_content("Answer body")
      end
    end

    scenario "creates answer with errors" do
      click_on I18n.t('answers.create.submit')
      expect(page).to have_content "Body can't be blank" 
    end

    scenario "creates an answer with attached files" do
      fill_in 'answer_body', with: 'Answer body'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('answers.create.submit')

        expect(page).to have_content("Answer body")
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
  end

  describe 'Unauthenticated user' do
    background do 
      visit question_path(question)
    end

    scenario "tries to create an answer to the question" do
      expect(page).not_to have_content I18n.t('answers.create.submit')
    end
  end
end