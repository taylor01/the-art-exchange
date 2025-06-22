require 'rails_helper'

RSpec.describe AuthenticationMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "#otp_email" do
    let(:otp_token) { "ABC123XYZ" }
    let(:mail) { AuthenticationMailer.otp_email(user, otp_token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your verification code for The Art Exchange")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "noreply@theartexchange.com" ])
    end

    it "includes the OTP token in the body" do
      expect(mail.body.encoded).to include(otp_token)
    end

    it "includes the user's first name" do
      expect(mail.body.encoded).to include(user.first_name)
    end

    it "includes expiration information" do
      expect(mail.body.encoded).to include("minutes")
    end
  end

  describe "#confirmation_email" do
    let(:mail) { AuthenticationMailer.confirmation_email(user) }

    before do
      user.generate_confirmation_token!
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your email for The Art Exchange")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "noreply@theartexchange.com" ])
    end

    it "includes confirmation link" do
      expect(mail.body.encoded).to include("confirm/#{user.confirmation_token}")
    end

    it "includes the user's first name" do
      expect(mail.body.encoded).to include(user.first_name)
    end
  end

  describe "#password_reset_email" do
    let(:mail) { AuthenticationMailer.password_reset_email(user) }

    before do
      user.generate_reset_password_token!
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Reset your password for The Art Exchange")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "noreply@theartexchange.com" ])
    end

    it "includes reset link" do
      expect(mail.body.encoded).to include("reset_password/#{user.reset_password_token}")
    end

    it "includes the user's first name" do
      expect(mail.body.encoded).to include(user.first_name)
    end
  end
end
