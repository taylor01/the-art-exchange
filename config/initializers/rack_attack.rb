class Rack::Attack
  # Always allow requests from localhost in development
  safelist("allow-localhost") do |req|
    Rails.env.development? && %w[127.0.0.1 ::1].include?(req.ip)
  end

  # Throttle authentication attempts
  throttle("auth/ip", limit: 5, period: 1.hour) do |req|
    if req.path =~ %r{^/(sign_in|sign_up|verify|forgot_password)} && req.post?
      req.ip
    end
  end

  # Throttle OTP requests per user
  throttle("otp/email", limit: 3, period: 1.hour) do |req|
    if req.path =~ %r{^/(sign_in|verify/resend)} && req.post?
      email = req.params.dig("email")&.downcase&.strip
      "otp-#{email}" if email.present?
    end
  end

  # Throttle password reset requests
  throttle("password_reset/email", limit: 3, period: 1.hour) do |req|
    if req.path == "/forgot_password" && req.post?
      email = req.params.dig("email")&.downcase&.strip
      "reset-#{email}" if email.present?
    end
  end

  # General request throttling disabled for browsing-heavy poster app
  # Auth-specific rate limits above are sufficient for security
  # Unlimited browsing allows infinite scroll, AJAX, prefetch, and image loading

  # Custom response for throttled requests
  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]

    headers = {
      "RateLimit-Limit" => match_data[:limit].to_s,
      "RateLimit-Remaining" => "0",
      "RateLimit-Reset" => (now + (match_data[:period] - now % match_data[:period])).to_s,
      "Retry-After" => match_data[:period].to_s,
      "Content-Type" => "application/json"
    }

    error_message = if request.env["rack.attack.matched"] =~ /auth/
      "Too many authentication attempts. Please try again later."
    else
      "Rate limit exceeded. Please try again later."
    end

    [ 429, headers, [ { error: error_message }.to_json ] ]
  end
end

# Enable rack-attack in all environments except test
Rails.application.config.middleware.use Rack::Attack unless Rails.env.test?
