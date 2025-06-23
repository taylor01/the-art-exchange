FactoryBot.define do
  factory :series do
    name { Faker::Lorem.words(number: 3).join(' ').titleize + " Series" }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    year { Faker::Number.between(from: 1965, to: Date.current.year) }
    total_count { Faker::Number.between(from: 3, to: 12) }

    trait :playing_cards do
      name { "Playing Card Series" }
      description { "A series of five posters based on playing cards: Joker, King, Queen, Jack, and 10 of Spades, created for Dave Matthews Band's summer tour." }
      year { 2003 }
      total_count { 5 }
    end

    trait :grateful_dead_europe do
      name { "Grateful Dead European Tour" }
      description { "Poster series for the Grateful Dead's legendary 1972 European tour, featuring psychedelic artwork from various artists." }
      year { 1972 }
      total_count { 8 }
    end

    trait :fillmore_west do
      name { "Fillmore West Concert Series" }
      description { "Classic concert poster series from the iconic Fillmore West venue in San Francisco during the height of the psychedelic era." }
      year { 1967 }
      total_count { 12 }
    end

    trait :modern_series do
      name { "Contemporary Art Rock Series" }
      description { "Modern poster series featuring contemporary design aesthetics for indie rock concerts." }
      year { 2020 }
      total_count { 6 }
    end

    trait :vintage_series do
      name { "Vintage Blues Series" }
      description { "Classic blues concert posters from the golden age of poster art." }
      year { 1969 }
      total_count { 4 }
    end

    trait :without_total_count do
      total_count { nil }
    end

    trait :large_series do
      name { "Festival Season Series" }
      description { "Extensive series covering an entire festival season with multiple artists and venues." }
      total_count { 25 }
    end
  end
end