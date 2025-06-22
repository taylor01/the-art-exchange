RSpec.configure do |config|
  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.before(:each, type: :controller) do
    # Stub mailer delivery for controller tests to avoid Mailgun errors
    # Only stub if not already stubbed by the test itself
    unless RSpec.current_example.metadata[:unstub_mailers]
      mailer_double = double("AuthenticationMailer")
      allow(mailer_double).to receive(:deliver_now).and_return(true)

      allow(AuthenticationMailer).to receive(:otp_email).and_return(mailer_double)
      allow(AuthenticationMailer).to receive(:confirmation_email).and_return(mailer_double)
      allow(AuthenticationMailer).to receive(:password_reset_email).and_return(mailer_double)
    end
  end
end
