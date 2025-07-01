class AuthenticationMailerPreview < ActionMailer::Preview
  def otp_email
    user = User.first || create_sample_user
    otp_token = "123456"
    AuthenticationMailer.otp_email(user, otp_token)
  end

  def confirmation_email
    user = User.first || create_sample_user
    AuthenticationMailer.confirmation_email(user)
  end

  def password_reset_email
    user = User.first || create_sample_user
    # Ensure the user has a reset token for the preview
    user.reset_password_token ||= "sample_reset_token_123456"
    AuthenticationMailer.password_reset_email(user)
  end

  def welcome_email
    user = User.first || create_sample_user
    AuthenticationMailer.welcome_email(user)
  end

  private

  def create_sample_user
    User.new(
      email: "preview@example.com",
      first_name: "John",
      last_name: "Doe",
      confirmation_token: "sample_confirmation_token",
      reset_password_token: "sample_reset_token_123456"
    )
  end
end