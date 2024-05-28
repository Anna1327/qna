FactoryBot.define do
  factory :authorization do
    provider { "github" }
    uid { "123" }
    user
  end
end
