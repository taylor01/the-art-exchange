FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :admin do
      admin { true }
    end

    trait :with_password do
      password { "SecurePassword123!" }
    end

    trait :locked do
      locked_until { 1.hour.from_now }
      failed_login_attempts { 5 }
    end

    trait :otp_locked do
      otp_locked_until { 15.minutes.from_now }
      otp_attempts_count { 3 }
    end

    trait :with_provider do
      provider { "google_oauth2" }
      uid { Faker::Number.number(digits: 10).to_s }
      provider_data { { "info" => { "email" => email, "name" => "#{first_name} #{last_name}" } } }
    end

    # Profile traits
    trait :with_complete_profile do
      bio { Faker::Lorem.paragraph(sentence_count: 3) }
      location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }
      website { Faker::Internet.url }
      phone { "#{Faker::PhoneNumber.area_code}-555-#{Faker::Number.number(digits: 4)}" }
      collector_since { Faker::Date.between(from: 10.years.ago, to: 1.year.ago) }
      preferred_contact_method { [ 'email', 'phone', 'both' ].sample }
      instagram_handle { Faker::Internet.username(specifier: 3..15).gsub(/[^a-zA-Z0-9._]/, '') }
      twitter_handle { Faker::Internet.username(specifier: 3..12).gsub(/[^a-zA-Z0-9_]/, '') }
    end

    trait :new_collector do
      collector_since { 6.months.ago }
      bio { "New to poster collecting but passionate about art!" }
      location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }
    end

    trait :experienced_collector do
      collector_since { 8.years.ago }
      bio { "Long-time collector with a focus on vintage concert posters and modern art prints." }
      location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }
      website { Faker::Internet.url }
      instagram_handle { Faker::Internet.username(specifier: 5..15).gsub(/[^a-zA-Z0-9._]/, '') }
    end

    trait :social_collector do
      instagram_handle { Faker::Internet.username(specifier: 3..15).gsub(/[^a-zA-Z0-9._]/, '') }
      twitter_handle { Faker::Internet.username(specifier: 3..12).gsub(/[^a-zA-Z0-9_]/, '') }
      website { Faker::Internet.url }
    end
  end
end
