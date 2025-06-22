Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"],
    {
      scope: "email,profile",
      prompt: "consent",
      image_aspect_ratio: "square",
      image_size: 50,
      access_type: "offline"
    }

  provider :facebook,
    ENV["FACEBOOK_APP_ID"],
    ENV["FACEBOOK_APP_SECRET"],
    {
      scope: "email",
      info_fields: "email,first_name,last_name,name"
    }

  provider :apple,
    ENV["APPLE_CLIENT_ID"],
    "",
    {
      scope: "email name",
      team_id: ENV["APPLE_TEAM_ID"],
      key_id: ENV["APPLE_KEY_ID"],
      pem: ENV["APPLE_PRIVATE_KEY"]
    }
end

# Configure Omniauth security settings
OmniAuth.config.allowed_request_methods = [ :post ]
OmniAuth.config.silence_get_warning = true
