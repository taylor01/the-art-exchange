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

    trait :pearl_jam do
      name { "Pearl Jam" }
      website { "https://pearljam.com" }
    end

    trait :radiohead do
      name { "Radiohead" }
      website { "https://radiohead.com" }
    end

    trait :the_black_keys do
      name { "The Black Keys" }
      website { "https://theblackkeys.com" }
    end

    trait :arctic_monkeys do
      name { "Arctic Monkeys" }
      website { "https://arcticmonkeys.com" }
    end

    trait :tame_impala do
      name { "Tame Impala" }
      website { "https://tameimpala.com" }
    end

    trait :foo_fighters do
      name { "Foo Fighters" }
      website { "https://foofighters.com" }
    end

    trait :kings_of_leon do
      name { "Kings of Leon" }
      website { "https://kingsofleon.com" }
    end
  end
end
