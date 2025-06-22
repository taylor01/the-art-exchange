Rails.application.configure do
  # Security headers configuration
  config.force_ssl = Rails.env.production?

  # Content Security Policy
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https, :unsafe_inline

    # Allow OAuth providers
    policy.connect_src :self, :https, "https://accounts.google.com", "https://www.facebook.com", "https://appleid.apple.com"
    policy.frame_src   "https://accounts.google.com", "https://www.facebook.com", "https://appleid.apple.com"

    # Development environment adjustments
    if Rails.env.development?
      policy.script_src :self, :https, :unsafe_eval
      policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035"
    end
  end

  # Additional security headers
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]

  # Prevent MIME type sniffing
  config.public_file_server.headers = {
    "X-Content-Type-Options" => "nosniff",
    "X-Frame-Options" => "DENY",
    "X-XSS-Protection" => "1; mode=block",
    "Referrer-Policy" => "strict-origin-when-cross-origin"
  }
end
