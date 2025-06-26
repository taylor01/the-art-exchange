FactoryBot.define do
  factory :search_analytic do
    query { "MyString" }
    facet_filters { "" }
    results_count { 1 }
    user { nil }
    performed_at { "2025-06-25 18:40:05" }
  end
end
