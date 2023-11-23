FactoryBot.define do
  factory :answer do
    body { "MyText" }
    correct { false }
    question { nil }
  end
end
