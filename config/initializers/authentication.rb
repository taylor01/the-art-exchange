Rails.application.configure do
  # Authentication configuration - easily adjustable timeouts and limits
  config.authentication = {
    # OTP (One-Time Password) settings
    otp_expires_in: Rails.env.production? ? 10.minutes : 30.minutes,
    otp_max_attempts: 3,
    otp_lockout_duration: Rails.env.production? ? 15.minutes : 5.minutes,
    otp_rate_limit: Rails.env.production? ? 5 : 20, # requests per hour

    # Session settings
    session_timeout: 30.days,
    remember_me_timeout: 90.days,

    # Account security
    max_failed_login_attempts: 5,
    account_lockout_duration: 30.minutes,

    # Email verification
    email_verification_expires_in: 24.hours,

    # Password settings (for optional traditional passwords)
    password_min_length: 8,
    password_require_special_chars: true,

    # Terms of Service versioning
    current_terms_version: "2024-06-28"
  }
end
