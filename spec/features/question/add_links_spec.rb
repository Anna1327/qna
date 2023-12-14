# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/Anna1327/176c70dc13cd0fd5688fc4da127416c5' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit new_question_path
    end

    scenario 'User can add link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on "Add link"

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'User can add multiple links when asks question' do
      url = 'https://thinknetica.com/'

      click_on "Add link"

      within all('.nested_fields').last do
        fill_in 'Link name', with: 'Thinknetica'
        fill_in 'Url', with: url
      end
    end
  end
end