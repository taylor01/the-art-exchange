FactoryBot.define do
  factory :poster_slug_redirect do
    sequence(:old_slug) { |n| "old-test-slug-#{n}" }
    association :poster
  end
end
