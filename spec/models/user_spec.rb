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

    describe 'terms of service acceptance' do
      it 'requires terms acceptance on create' do
        user.terms_accepted_at = nil
        expect(user).not_to be_valid
        expect(user.errors[:terms_accepted_at]).to include('You must accept the Terms of Service to create an account')
      end

      it 'accepts recent terms acceptance' do
        user.terms_accepted_at = 30.minutes.ago
        expect(user).to be_valid
      end

      it 'rejects future terms acceptance' do
        user.terms_accepted_at = 1.hour.from_now
        expect(user).not_to be_valid
        expect(user.errors[:terms_accepted_at]).to include('cannot be in the future')
      end

      it 'rejects old terms acceptance' do
        user.terms_accepted_at = 2.hours.ago
        expect(user).not_to be_valid
        expect(user.errors[:terms_accepted_at]).to include('acceptance must be recent (within the last hour)')
      end

      it 'allows updating existing users without terms validation' do
        user.terms_accepted_at = Time.current
        user.save!

        user.reload
        user.first_name = 'Updated'
        expect(user).to be_valid
      end
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

  describe 'profile field validations' do
    let(:user) { build(:user) }

    it 'validates website format' do
      user.website = 'invalid-url'
      expect(user).not_to be_valid
      expect(user.errors[:website]).to include('is invalid')
    end

    it 'allows valid website URLs' do
      user.website = 'https://example.com'
      expect(user).to be_valid
    end

    it 'validates phone format' do
      user.phone = 'invalid-phone'
      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include('is invalid')
    end

    it 'allows valid phone numbers' do
      user.phone = '+1-555-123-4567'
      expect(user).to be_valid
    end

    it 'validates bio length' do
      user.bio = 'a' * 1001
      expect(user).not_to be_valid
      expect(user.errors[:bio]).to include('is too long (maximum is 1000 characters)')
    end

    it 'validates Instagram handle format' do
      user.instagram_handle = 'invalid@handle'
      expect(user).not_to be_valid
      expect(user.errors[:instagram_handle]).to include('is invalid')
    end

    it 'allows valid Instagram handles' do
      user.instagram_handle = 'valid_handle123'
      expect(user).to be_valid
    end

    it 'validates Twitter handle format' do
      user.twitter_handle = 'too_long_handle_name'
      expect(user).not_to be_valid
      expect(user.errors[:twitter_handle]).to include('is invalid')
    end

    it 'allows valid Twitter handles' do
      user.twitter_handle = 'valid_handle'
      expect(user).to be_valid
    end
  end

  describe 'preferred_contact_method enum' do
    let(:user) { create(:user) }

    it 'has email as default' do
      expect(user.preferred_contact_method).to eq('email')
    end

    it 'allows valid contact methods' do
      user.preferred_contact_method = 'phone'
      expect(user).to be_valid
      expect(user.preferred_contact_method).to eq('phone')
    end

    it 'allows both contact methods' do
      user.preferred_contact_method = 'both'
      expect(user).to be_valid
      expect(user.preferred_contact_method).to eq('both')
    end
  end

  describe 'profile helper methods' do
    describe '#profile_complete?' do
      it 'returns false for incomplete profile' do
        user = create(:user)
        expect(user.profile_complete?).to be false
      end

      it 'returns true for complete profile' do
        user = create(:user, :with_complete_profile)
        expect(user.profile_complete?).to be true
      end
    end

    describe '#collecting_experience_years' do
      it 'returns 0 for no collector_since date' do
        user = create(:user)
        expect(user.collecting_experience_years).to eq(0)
      end

      it 'calculates years correctly' do
        user = create(:user, collector_since: 3.years.ago)
        expect(user.collecting_experience_years).to eq(3)
      end
    end

    describe '#new_collector?' do
      it 'returns true for collectors with less than 2 years experience' do
        user = create(:user, :new_collector)
        expect(user.new_collector?).to be true
      end

      it 'returns false for experienced collectors' do
        user = create(:user, :experienced_collector)
        expect(user.new_collector?).to be false
      end
    end

    describe '#experienced_collector?' do
      it 'returns true for collectors with 5+ years experience' do
        user = create(:user, :experienced_collector)
        expect(user.experienced_collector?).to be true
      end

      it 'returns false for new collectors' do
        user = create(:user, :new_collector)
        expect(user.experienced_collector?).to be false
      end
    end

    describe 'social media URLs' do
      let(:user) { create(:user, :social_collector) }

      it 'generates Instagram URL' do
        user.instagram_handle = 'test_user'
        expect(user.instagram_url).to eq('https://instagram.com/test_user')
      end

      it 'returns nil for empty Instagram handle' do
        user.instagram_handle = nil
        expect(user.instagram_url).to be_nil
      end

      it 'generates Twitter URL' do
        user.twitter_handle = 'test_user'
        expect(user.twitter_url).to eq('https://twitter.com/test_user')
      end

      it 'returns nil for empty Twitter handle' do
        user.twitter_handle = nil
        expect(user.twitter_url).to be_nil
      end
    end

    describe 'contact preference helpers' do
      it 'detects phone contact preference' do
        user = create(:user, preferred_contact_method: 'phone')
        expect(user.prefers_phone_contact?).to be true
        expect(user.prefers_email_contact?).to be false
      end

      it 'detects email contact preference' do
        user = create(:user, preferred_contact_method: 'email')
        expect(user.prefers_email_contact?).to be true
        expect(user.prefers_phone_contact?).to be false
      end

      it 'detects both contact preferences' do
        user = create(:user, preferred_contact_method: 'both')
        expect(user.prefers_phone_contact?).to be true
        expect(user.prefers_email_contact?).to be true
      end
    end

    describe 'terms acceptance methods' do
      let(:user) { create(:user, terms_accepted_at: Time.current) }

      describe '#terms_accepted?' do
        it 'returns true when terms_accepted_at is present' do
          expect(user.terms_accepted?).to be true
        end

        it 'returns false when terms_accepted_at is nil' do
          user.update_column(:terms_accepted_at, nil)
          expect(user.terms_accepted?).to be false
        end
      end

      describe '#terms_acceptance_current?' do
        it 'returns true for recent acceptance' do
          user.update_column(:terms_accepted_at, 6.months.ago)
          expect(user.terms_acceptance_current?).to be true
        end

        it 'returns false for old acceptance' do
          user.update_column(:terms_accepted_at, 2.years.ago)
          expect(user.terms_acceptance_current?).to be false
        end

        it 'returns false when terms not accepted' do
          user.update_column(:terms_accepted_at, nil)
          expect(user.terms_acceptance_current?).to be false
        end
      end

      describe '#accept_terms!' do
        it 'sets terms_accepted_at to current time' do
          user.update_column(:terms_accepted_at, nil)
          expect { user.accept_terms! }.to change { user.terms_accepted_at }.from(nil)
          expect(user.terms_accepted_at).to be_within(1.second).of(Time.current)
        end
      end
    end
  end
end
