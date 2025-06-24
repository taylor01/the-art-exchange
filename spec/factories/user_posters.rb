FactoryBot.define do
  factory :user_poster do
    association :user
    association :poster
    status { "watching" }

    trait :owned do
      status { "owned" }
      condition { [ "mint", "near_mint", "very_fine", "fine" ].sample }
      purchase_price { [ 25.00, 35.00, 50.00, 75.00, 100.00 ].sample }
      purchase_date { Faker::Date.between(from: 2.years.ago, to: 1.week.ago) }
    end

    trait :wanted do
      status { "wanted" }
    end

    trait :for_sale do
      status { "owned" }
      for_sale { true }
      asking_price { 75.00 }
    end

    trait :with_edition do
      edition_number { rand(1..999) }
    end

    trait :with_notes do
      notes { [ "Great condition poster from an amazing show", "Bought at the venue", "Perfect addition to my collection", "Rare find!", "One of my favorites" ].sample }
    end

    trait :valuable do
      status { "owned" }
      condition { "mint" }
      purchase_price { [ 100.00, 150.00, 200.00, 300.00 ].sample }
      for_sale { [ true, false ].sample }
      asking_price { purchase_price * [ 1.5, 2.0, 2.5 ].sample if for_sale }
    end

    trait :damaged do
      status { "owned" }
      condition { [ "good", "fair", "poor" ].sample }
      purchase_price { [ 10.00, 15.00, 20.00, 25.00 ].sample }
      notes { "Some wear but still a great piece" }
    end
  end
end
