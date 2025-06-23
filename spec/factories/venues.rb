FactoryBot.define do
  factory :venue do
    name { "Test Theater" }
    address { "123 Main Street" }
    city { "New York" }
    administrative_area { "NY" }
    postal_code { "10001" }
    country { "US" }
    latitude { 40.7589 }
    longitude { -73.9851 }
    website { "https://example.com" }
    email { "contact@venue.com" }
    telephone_number { "555-123-4567" }
    capacity { 500 }
    venue_type { "theater" }
    status { "active" }
    description { "A test venue for testing purposes." }
    previous_names { [] }

    trait :theater do
      venue_type { "theater" }
      name { "Test Theater" }
      capacity { 800 }
    end

    trait :club do
      venue_type { "club" }
      name { "Test Club" }
      capacity { 200 }
    end

    trait :arena do
      venue_type { "arena" }
      name { "Test Arena" }
      capacity { 15000 }
    end

    trait :closed do
      status { "closed" }
    end

    trait :without_geocoding do
      latitude { nil }
      longitude { nil }
    end

    trait :with_previous_names do
      previous_names { [ "Old Theater Name", "Historic Venue" ] }
    end

    trait :international do
      country { "CA" }
      administrative_area { "ON" }
      postal_code { "M5V 3A8" }
    end
  end
end
