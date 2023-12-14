# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create :user }

  describe 'Authenticated user', js: true do
    given(:gist_url) { 'https://gist.github.com/Anna1327/176c70dc13cd0fd5688fc4da127416c5' }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on I18n.t('links.new.add_link')
    end

    context 'User can to add link with valid params' do
      background do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      scenario 'add link when asks question' do
        click_on I18n.t('questions.new.ask')
        expect(page).to have_link 'My gist', href: gist_url
      end

      scenario 'add multiple links when asks question' do
        url = 'https://thinknetica.com/'

        click_on I18n.t('links.new.add_link')

        within all('.nested_fields').last do
          fill_in 'Link name', with: 'Thinknetica'
          fill_in 'Url', with: url
        end

        click_on I18n.t('questions.new.ask')

        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Thinknetica', href: url
      end

      context 'User can not to add link with invalid params' do
        background do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: 'url'
          click_on I18n.t('questions.new.ask')
        end
  
        scenario 'with invalid url' do
          expect(page).not_to have_link 'My gist', href: 'url'
          expect(page).to have_content 'Links url is invalid'
        end
      end
    end
  end
end