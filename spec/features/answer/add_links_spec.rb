# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/Anna1327/176c70dc13cd0fd5688fc4da127416c5' }
  given(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer body'
    end

    context 'User can to add link with valid params' do
      background do
        within '.answers' do
          click_on I18n.t('links.new.add_link')
  
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end
      end

      scenario 'User can add link when give an answer' do  
        within '.answers' do
          click_on I18n.t('answers.create.submit')
          expect(page).to have_link 'My gist', href: gist_url
        end
      end

      scenario 'User can add multiple links when give an answer' do
        url = 'https://thinknetica.com/'

        within '.answers' do
          click_on I18n.t('links.new.add_link')

          within all('.nested-fields').last do
            fill_in 'Link name', with: 'Thinknetica'
            fill_in 'Url', with: url
          end

          click_on I18n.t('answers.create.submit')

          expect(page).to have_link 'My gist', href: gist_url
          expect(page).to have_link 'Thinknetica', href: url
        end
      end
    end

    context 'User can not to add link with invalid params' do
      background do
        within '.answers' do
          click_on I18n.t('links.new.add_link')
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: 'url'
          click_on I18n.t('answers.create.submit')
        end
      end

      scenario 'with invalid url' do
        expect(page).not_to have_link 'My gist', href: 'url'
        expect(page).to have_content 'Links url is invalid'
      end
    end
  end
end