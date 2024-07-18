# frozen_string_literal: true

FactoryBot.define do
  factory :subscriber do
    question { create :question }
    author { create :user }
  end
end