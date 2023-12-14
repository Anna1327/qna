# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on I18n.t('questions.show.edit_answer')
    end

    scenario "edits his answer" do
      within ".answers form#edit-answer-#{answer.id}" do
        fill_in 'Body', with: 'Updated answer'
        click_button I18n.t('answers.edit.update')

        expect(page).not_to have_content(answer.body)
        expect(page).to have_content('Updated answer')
        expect(page).not_to have_selector('div.textarea')
      end
    end

    scenario "edits his answer with errors" do
      within ".answers form#edit-answer-#{answer.id}" do
        fill_in 'answer_body', with: ""
        click_button I18n.t('answers.edit.update')
      end
      within ".answers" do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "can to add files when edits his answer" do
      within ".answers form#edit-answer-#{answer.id}" do
        attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_button I18n.t('answers.edit.update')
      end
      within ".answers" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "can delete files when edits his answer" do
      within ".answers li#answer-#{answer.id}" do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('answers.edit.update')

        find("#answer_#{answer.id}_files").first(:link, 'Delete file').click
        expect(page).not_to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe "Authenticated other user", js: true do
    given(:other_user) { create(:user) }

    scenario "tries to edit other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).not_to have_link I18n.t('questions.show.edit_answer')
    end
  end

  describe "Unauthenticated user" do
    scenario "can not edit answer" do
      visit questions_path

      expect(page).not_to have_link I18n.t('questions.show.edit_answer')
    end
  end
end