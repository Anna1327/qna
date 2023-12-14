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

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can add link when give an answer', js: true do
      fill_in 'answer_body', with: 'Answer body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on I18n.t('answers.create.submit')

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end
end