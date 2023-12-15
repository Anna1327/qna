# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can edit his question', %q{
  In order to correct the question
  As an author of question
  I'd like to be able to edit my question
  } do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can edit his question' do
      click_on I18n.t('questions.edit.update')

      within '.question' do
        fill_in 'Title', with: 'Title updated'
        fill_in 'Body', with: 'Body updated'
        click_on I18n.t('questions.edit.update')

        expect(page).to have_content('Title updated')
        expect(page).to have_content('Body updated')
        expect(page).not_to have_selector('div.textarea')
      end
    end

    scenario 'can edit his question with errors' do
      click_on I18n.t('questions.edit.update')

      within '.question' do
        fill_in 'Title', with: ''
        click_on I18n.t('questions.edit.update')

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'can add files when edit his question' do
      click_on I18n.t('questions.edit.update')

      within '.question' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('questions.edit.update')

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can delete files when edit his question' do
      click_on I18n.t('questions.edit.update')

      within '.question' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('questions.edit.update')

        find('p#question_files').first(:link, 'Delete').click

        expect(page).not_to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can add links when edit his question' do
      thinknetica_url = 'https://thinknetica.com/'

      click_on I18n.t('questions.edit.update')

      within '.question' do
        click_on I18n.t('links.new.add_link')

        within all('.nested_fields').last do
          fill_in 'Link name', with: 'Thinknetica'
          fill_in 'Url', with: thinknetica_url
        end

        click_on I18n.t('questions.edit.update')
      end

      expect(page).to have_link 'Thinknetica', href: thinknetica_url
    end
  end

  describe 'Authenticated other user', js: true do
    given(:other_user) { create :user }

    scenario "tries to update other's question" do
      sign_in(other_user)
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link I18n.t('questions.edit.update')
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can not edit answer' do
      visit question_path(question)
  
      expect(page).not_to have_link I18n.t('questions.edit.update')
    end
  end
end