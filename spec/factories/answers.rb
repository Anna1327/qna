FactoryBot.define do
  factory :answer do
    body { 'Body of the answer' }
    correct { false }
    question

    trait :invalid do
      body { nil }
    end
  end
end
