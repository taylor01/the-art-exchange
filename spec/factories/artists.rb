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

    trait :shepard_fairey do
      name { "Shepard Fairey" }
      website { "https://obeygiant.com" }
    end

    trait :david_juniper do
      name { "David Juniper" }
      website { "https://davidjuniper.com" }
    end

    trait :emek do
      name { "Emek" }
      website { "https://emekstudio.com" }
    end

    trait :ames_bros do
      name { "Ames Bros" }
      website { "https://amesbros.com" }
    end
  end
end
