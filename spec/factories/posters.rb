FactoryBot.define do
  factory :poster do
    sequence(:name) { |n| "#{Faker::Music.band} Live #{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    release_date { Faker::Date.between(from: 5.years.ago, to: 1.year.from_now) }
    original_price { [ 25.00, 35.00, 45.00, 55.00, 65.00 ].sample }

    association :band
    association :venue

    # Traits for different poster types
    trait :vintage do
      release_date { Faker::Date.between(from: 50.years.ago, to: 30.years.ago) }
      original_price { 5.00 }
    end

    trait :golden_age do
      release_date { Faker::Date.between(from: Date.new(1965), to: Date.new(1975)) }
      original_price { 10.00 }
    end

    trait :modern do
      release_date { Faker::Date.between(from: 10.years.ago, to: Date.current) }
      original_price { 50.00 }
    end

    trait :with_artist do
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end

    trait :collaborative do
      after(:create) do |poster|
        poster.artists << create_list(:artist, 2)
      end
    end

    trait :in_series do
      after(:create) do |poster|
        poster.series << create(:series)
      end
    end

    trait :expensive do
      original_price { 100.00 }
    end

    trait :no_price do
      original_price { nil }
    end

    # Specific realistic poster combinations
    trait :pearl_jam_red_rocks do
      name { "Pearl Jam - Red Rocks Amphitheatre" }
      description { "Limited edition screen print poster commemorating Pearl Jam's legendary performance at Red Rocks. Features stunning mountain imagery with psychedelic color gradients." }
      release_date { Date.new(2023, 7, 15) }
      original_price { 35.00 }
      band { association(:band, :pearl_jam) }
      venue { association(:venue, :red_rocks) }
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end

    trait :radiohead_msg do
      name { "Radiohead - Madison Square Garden 2024" }
      description { "Official tour poster for Radiohead's acclaimed 2024 world tour stop at Madison Square Garden. Minimalist design with geometric patterns." }
      release_date { Date.new(2024, 3, 22) }
      original_price { 45.00 }
      band { association(:band, :radiohead) }
      venue { association(:venue, :madison_square_garden) }
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end

    trait :black_keys_fillmore do
      name { "The Black Keys - Fillmore Sessions" }
      description { "Vintage-inspired poster celebrating The Black Keys' intimate performance at the legendary Fillmore. Hand-lettered typography with blues-inspired artwork." }
      release_date { Date.new(2023, 11, 8) }
      original_price { 30.00 }
      band { association(:band, :the_black_keys) }
      venue { association(:venue, :fillmore) }
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end

    trait :arctic_monkeys_wembley do
      name { "Arctic Monkeys - Wembley Stadium" }
      description { "Commemorative poster for Arctic Monkeys' sold-out Wembley Stadium show. Features iconic London skyline with band imagery." }
      release_date { Date.new(2023, 6, 25) }
      original_price { 40.00 }
      band { association(:band, :arctic_monkeys) }
      venue { association(:venue, :wembley_stadium) }
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end

    trait :tame_impala_observatory do
      name { "Tame Impala - Observatory Experimental Set" }
      description { "Psychedelic masterpiece poster for Tame Impala's experimental performance. Features kaleidoscopic patterns and vibrant color schemes." }
      release_date { Date.new(2024, 2, 14) }
      original_price { 50.00 }
      band { association(:band, :tame_impala) }
      venue { association(:venue, :the_observatory) }
      after(:create) do |poster|
        poster.artists << create(:artist)
      end
    end
  end
end
