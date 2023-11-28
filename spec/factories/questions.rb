FactoryBot.define do
  factory :question do
    title { "Title of the question" }
    body { "Body of the question" }

    trait :invalid do
      title { nil }
    end
  end
end
