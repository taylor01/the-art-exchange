FactoryBot.define do
  factory :user_poster do
    association :user
    association :poster
    status { "watching" }

    trait :owned do
      status { "owned" }
      condition { "mint" }
      purchase_price { 50.00 }
      purchase_date { 1.month.ago }
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
      edition_number { "#{rand(1..100)}/#{rand(100..500)}" }
    end

    trait :with_notes do
      notes { "Great condition poster from an amazing show" }
    end
  end
end
