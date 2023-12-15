FactoryBot.define do
  factory :reward do
    title { 'Reward title' }
    image do
      image_path = Rails.root.join('app', 'assets', 'images', 'badge.png')
      attach(io: File.open(image_path), filename: 'badge.png')
    end
  end
end
