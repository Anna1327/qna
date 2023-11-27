# frozen_string_literal: true

require 'rails_helper'

feature 'User view a list of questions', %q{
  In order to find a question
  As an user
  I'd like to be able view a list of questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe "Authenticated user" do
    background do 
      sign_in(user)
      visit questions_path
    end

    scenario "can see a list of all questions" do
      expect(page).to have_content "#{question.title}"
      expect(page).to have_content "#{question.body}"
    end
  end

  describe "Unauthenticated user" do
    background do
      visit questions_path
    end

    scenario "can see a list of all questions" do
      expect(page).to have_content "#{question.title}"
      expect(page).to have_content "#{question.body}"
    end
  end
end