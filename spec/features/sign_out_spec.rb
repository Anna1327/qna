# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', %q{
  In order to end session
  As an authorized User
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    click_on I18n.t('main.sign_out')
  end

  scenario "Authorized user tries to sign out", js: true do
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end