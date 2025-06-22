require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'requires an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires a unique email' do
      create(:user, email: 'test@example.com')
      user.email = 'test@example.com'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'validates email format' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'requires first_name' do
      user.first_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'requires last_name' do
      user.last_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'normalizes email to lowercase' do
      user.email = 'TEST@EXAMPLE.COM'
      user.save!
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'confirmation' do
    it 'generates confirmation token on create' do
      user = create(:user, :unconfirmed)
      expect(user.confirmation_token).to be_present
      expect(user.confirmation_sent_at).to be_present
    end

    it 'is not confirmed by default' do
      user = create(:user, :unconfirmed)
      expect(user).not_to be_confirmed
    end

    it 'can be confirmed' do
      user = create(:user, :unconfirmed)
      user.confirm!
      expect(user).to be_confirmed
      expect(user.confirmation_token).to be_nil
    end

    it 'detects expired confirmations' do
      user = create(:user, :unconfirmed)
      user.update!(confirmation_sent_at: 25.hours.ago)
      expect(user).to be_confirmation_expired
    end
  end

  describe 'OTP authentication' do
    let(:user) { create(:user) }

    it 'generates OTP token' do
      token = user.generate_otp!
      expect(token).to be_present
      expect(user.otp_secret_key).to eq(token)
      expect(user.otp_sent_at).to be_present
      expect(user.otp_attempts_count).to eq(0)
    end

    it 'verifies valid OTP' do
      token = user.generate_otp!
      expect(user.verify_otp(token)).to be true
      expect(user.otp_used_at).to be_present
      expect(user.last_login_at).to be_present
    end

    it 'rejects invalid OTP' do
      user.generate_otp!
      expect(user.verify_otp('invalid-token')).to be false
      expect(user.otp_attempts_count).to eq(1)
    end

    it 'locks account after max attempts' do
      user.generate_otp!
      3.times { user.verify_otp('invalid-token') }
      expect(user).to be_otp_locked
    end

    it 'detects expired OTP' do
      user.generate_otp!
      # Use production timeout value to ensure test works
      expired_time = Rails.application.config.authentication[:otp_expires_in] + 1.minute
      user.update!(otp_sent_at: expired_time.ago)
      expect(user).to be_otp_expired
    end

    it 'detects used OTP' do
      token = user.generate_otp!
      user.verify_otp(token)
      expect(user).to be_otp_used
      expect(user.verify_otp(token)).to be false
    end
  end

  describe 'account security' do
    let(:user) { create(:user) }

    it 'can lock account' do
      user.lock_account!
      expect(user).to be_locked
      expect(user.failed_login_attempts).to eq(0)
    end

    it 'can unlock account' do
      user.lock_account!
      user.unlock_account!
      expect(user).not_to be_locked
    end
  end

  describe 'password reset' do
    let(:user) { create(:user) }

    it 'generates reset token' do
      user.generate_reset_password_token!
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_present
    end

    it 'detects expired reset tokens' do
      user.generate_reset_password_token!
      user.update!(reset_password_sent_at: 3.hours.ago)
      expect(user).to be_reset_password_expired
    end
  end

  describe 'Omniauth' do
    let(:auth_hash) do
      {
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          name: 'John Doe'
        }
      }
    end

    it 'creates user from omniauth' do
      user = User.from_omniauth(auth_hash)
      expect(user).to be_persisted
      expect(user.email).to eq('test@example.com')
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user).to be_confirmed
    end

    it 'finds existing user from omniauth' do
      existing_user = create(:user, provider: 'google_oauth2', uid: '123456789')
      user = User.from_omniauth(auth_hash)
      expect(user).to eq(existing_user)
    end
  end

  describe 'display helpers' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns full name' do
      expect(user.full_name).to eq('John Doe')
    end

    it 'returns display name' do
      expect(user.display_name).to eq('John Doe')
    end

    it 'falls back to email for display name' do
      user.first_name = nil
      user.last_name = nil
      expect(user.display_name).to eq(user.email)
    end
  end

  describe 'scopes' do
    it 'finds confirmed users' do
      confirmed = create(:user)
      unconfirmed = create(:user, :unconfirmed)

      expect(User.confirmed).to include(confirmed)
      expect(User.confirmed).not_to include(unconfirmed)
    end

    it 'finds admin users' do
      admin = create(:user, :admin)
      regular = create(:user)

      expect(User.admin).to include(admin)
      expect(User.admin).not_to include(regular)
    end
  end
end
