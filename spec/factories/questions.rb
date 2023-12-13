FactoryBot.define do
  factory :question do
    title { "Title of the question" }
    body { "Body of the question" }
    best_answer { nil }

    trait :invalid do
      title { nil }
    end
  end
end
