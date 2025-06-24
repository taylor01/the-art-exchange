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

    trait :red_rocks do
      name { "Red Rocks Amphitheatre" }
      address { "18300 W Alameda Pkwy" }
      city { "Morrison" }
      administrative_area { "CO" }
      postal_code { "80465" }
      country { "US" }
      latitude { 39.6654 }
      longitude { -105.2057 }
      venue_type { "outdoor" }
      capacity { 9525 }
      description { "Iconic natural amphitheater carved into red sandstone" }
    end

    trait :fillmore do
      name { "The Fillmore" }
      address { "1805 Geary Blvd" }
      city { "San Francisco" }
      administrative_area { "CA" }
      postal_code { "94115" }
      country { "US" }
      latitude { 37.7849 }
      longitude { -122.4335 }
      venue_type { "theater" }
      capacity { 1150 }
      description { "Historic music venue in San Francisco" }
    end

    trait :madison_square_garden do
      name { "Madison Square Garden" }
      address { "4 Pennsylvania Plaza" }
      city { "New York" }
      administrative_area { "NY" }
      postal_code { "10001" }
      country { "US" }
      latitude { 40.7505 }
      longitude { -73.9934 }
      venue_type { "arena" }
      capacity { 20789 }
      description { "The world's most famous arena" }
    end

    trait :wembley_stadium do
      name { "Wembley Stadium" }
      address { "Wembley" }
      city { "London" }
      administrative_area { "England" }
      postal_code { "HA9 0WS" }
      country { "GB" }
      latitude { 51.5560 }
      longitude { -0.2799 }
      venue_type { "stadium" }
      capacity { 90000 }
      description { "Home of football and legendary concerts" }
    end

    trait :the_observatory do
      name { "The Observatory" }
      address { "2808 Kettner Blvd" }
      city { "San Diego" }
      administrative_area { "CA" }
      postal_code { "92101" }
      country { "US" }
      latitude { 32.7280 }
      longitude { -117.1695 }
      venue_type { "club" }
      capacity { 1100 }
      description { "Intimate music venue in North Park" }
    end
  end
end
