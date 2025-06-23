FactoryBot.define do
  factory :band do
    sequence(:name) { |n| "#{Faker::Music.band}_#{n}" }
    website { Faker::Internet.url }

    trait :without_website do
      website { nil }
    end

    trait :grateful_dead do
      name { "Grateful Dead" }
      website { "https://dead.net" }
    end

    trait :dave_matthews_band do
      name { "Dave Matthews Band" }
      website { "https://davematthewsband.com" }
    end

    trait :pink_floyd do
      name { "Pink Floyd" }
      website { "https://pinkfloyd.com" }
    end

    trait :jimi_hendrix do
      name { "Jimi Hendrix Experience" }
      website { nil }
    end
  end
end
