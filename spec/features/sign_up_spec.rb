# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to be able to ask questions
  As an unregistered User
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background do
    visit new_user_registration_path
  end

  describe 'Unregistered user tries to sign up' do
    scenario 'with valid params' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: 'newpassword123'
      fill_in 'Password confirmation', with: 'newpassword123'
      click_on 'Sign up'

      expect(page).to have_content I18n.t('devise.registrations.signed_up')
    end

    scenario 'with invalid password' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '123'
      fill_in 'Password confirmation', with: '123'
      click_on 'Sign up'

      expect(page).to have_content 'Password is too short'
      expect(page).to have_content I18n.t('errors.messages.not_saved.one',
                                          resource: user.class.to_s.downcase)
    end
  end

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(page).to have_content I18n.t('errors.messages.not_saved.one',
                                        resource: user.class.to_s.downcase)
  end
end
