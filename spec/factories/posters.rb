FactoryBot.define do
  factory :poster do
    name { Faker::Music.album }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    release_date { Faker::Date.between(from: 40.years.ago, to: Date.current) }
    original_price { 25.00 }
    
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
  end
end
