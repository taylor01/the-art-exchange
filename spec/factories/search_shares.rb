FactoryBot.define do
  factory :search_share do
    token { "MyString" }
    search_params { "MyText" }
    expires_at { "2025-06-25 18:39:50" }
  end
end
