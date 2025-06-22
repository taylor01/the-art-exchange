Rails.application.configure do
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
    api_key: Rails.application.credentials.mailgun_api_key,
    domain: Rails.application.credentials.mailgun_domain,
    api_host: "api.mailgun.net"
  }
end
