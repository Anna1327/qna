# frozen_string_literal: true

require 'rails_helper'
require 'letter_opener'

feature 'User can sign in', "
  In order to ask questions
  As an unathenticated User
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  context 'User tries sign in with github ' do
    given(:authorization) { create :authorization, user: user, provider: 'github', uid: '123456' }

    scenario 'user already has authorization' do
      visit new_user_session_path

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid: '123456',
                                                                    info: { email: user.email }
                                                                  })

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario 'user has not authorization' do
      visit new_user_session_path

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid: '123456',
                                                                    info: { email: 'user@test.com' }
                                                                  })

      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end
  end

  context 'user tries sign in with vkontakte' do
    scenario 'user already has authorization' do
      visit new_user_session_path

      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        { provider: 'vkontakte',
          uid: '123456' }
      )
      auth = OmniAuth.config.mock_auth[:vkontakte]
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s,
                                 confirmation_token: '123', confirm: true)

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'user has not authorization' do
      visit new_user_session_path

      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
                                                                       provider: 'vkontakte',
                                                                       uid: '654321'
                                                                     })

      click_on 'Sign in with Vkontakte'

      fill_in 'Email', with: user.email
      click_on 'Send'

      open_email(user.email)

      current_email.click_link 'Confirm your email'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end
end
