# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to reward users for best answer
  As an question's author
  I'd like to be able to create reward for best answer
} do

  given(:user) { create :user }
  given(:image) { Rails.root.join('app', 'assets', 'images', 'badge.png') }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on I18n.t('rewards.new.add_reward')
    end

    context 'User can to add reward with valid params' do
      background do
        fill_in 'Reward title', with: 'Best answer'
        attach_file 'Image', image
      end

      scenario 'add reward when asks question' do
        click_on I18n.t('questions.new.ask')
        expect(page).to have_content 'Test question'
      end

      context 'User can not to add reward with invalid params' do
        background do
          fill_in 'Reward title', with: 'Best answer'
          attach_file 'Image', Rails.root.join('spec', 'rails_helper.rb')
        end

        scenario 'with another file instead image' do
          click_on I18n.t('questions.new.ask')
  
          expect(page).to have_content I18n.t('rewards.errors.only_image')
        end
      end
    end
  end
end