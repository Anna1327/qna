# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 0 }
    author { create :user }
  end
end
