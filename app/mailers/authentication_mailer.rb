class AuthenticationMailer < ApplicationMailer
  default from: "noreply@theartexchange.com"

  def otp_email(user, otp_token)
    @user = user
    @otp_token = otp_token
    @expires_in_minutes = Rails.application.config.authentication[:otp_expires_in] / 1.minute

    mail(
      to: @user.email,
      subject: "Your verification code for The Art Exchange"
    )
  end

  def confirmation_email(user)
    @user = user
    @confirmation_url = confirmation_url(token: @user.confirmation_token)

    mail(
      to: @user.email,
      subject: "Confirm your email for The Art Exchange"
    )
  end

  def password_reset_email(user)
    @user = user
    @reset_url = password_reset_url(id: @user.reset_password_token)

    mail(
      to: @user.email,
      subject: "Reset your password for The Art Exchange"
    )
  end
end
