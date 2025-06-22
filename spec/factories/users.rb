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
  end
end
