FactoryBot.define do
  factory :artist do
    name { Faker::Name.name }
    website { Faker::Internet.url }

    trait :without_website do
      website { nil }
    end

    trait :famous_artist do
      name { "Stanley Mouse" }
      website { "https://stanleymouse.com" }
    end

    trait :griffin do
      name { "Rick Griffin" }
      website { "https://rickgriffin.com" }
    end

    trait :kelley do
      name { "Alton Kelley" }
      website { nil }
    end
  end
end
