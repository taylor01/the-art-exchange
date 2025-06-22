class User < ApplicationRecord
  has_secure_password validations: false

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Optional password validation
  validates :password, length: {
    minimum: Rails.application.config.authentication[:password_min_length]
  }, if: :password_digest_changed?

  # Callbacks
  before_validation :normalize_email
  before_create :generate_confirmation_token

  # Scopes
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :admin, -> { where(admin: true) }

  # Authentication configuration shortcuts
  def self.auth_config
    Rails.application.config.authentication
  end

  def auth_config
    self.class.auth_config
  end

  # Email confirmation
  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update!(confirmed_at: Time.current, confirmation_token: nil)
  end

  def generate_confirmation_token!
    self.confirmation_token = generate_token
    self.confirmation_sent_at = Time.current
    save!
  end

  def confirmation_expired?
    return false unless confirmation_sent_at
    confirmation_sent_at < auth_config[:email_verification_expires_in].ago
  end

  # OTP authentication
  def generate_otp!
    self.otp_secret_key = generate_token
    self.otp_sent_at = Time.current
    self.otp_used_at = nil
    self.otp_attempts_count = 0
    save!
    otp_secret_key
  end

  def verify_otp(token)
    return false if otp_locked? || otp_expired? || otp_used?

    if secure_compare(otp_secret_key, token)
      mark_otp_used!
      update_login_tracking!
      true
    else
      increment_otp_attempts!
      false
    end
  end

  def otp_locked?
    otp_locked_until.present? && otp_locked_until > Time.current
  end

  def otp_expired?
    return true unless otp_sent_at
    otp_sent_at < auth_config[:otp_expires_in].ago
  end

  def otp_used?
    otp_used_at.present?
  end

  def otp_valid?
    !otp_locked? && !otp_expired? && !otp_used? && otp_secret_key.present?
  end

  # Account security
  def locked?
    locked_until.present? && locked_until > Time.current
  end

  def lock_account!
    update!(
      locked_until: Time.current + auth_config[:account_lockout_duration],
      failed_login_attempts: 0
    )
  end

  def unlock_account!
    update!(locked_until: nil, failed_login_attempts: 0)
  end

  # Password reset
  def generate_reset_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.current
    save!
  end

  def reset_password_expired?
    return false unless reset_password_sent_at
    reset_password_sent_at < 2.hours.ago
  end

  # Omniauth
  def self.from_omniauth(auth)
    # Handle both Omniauth::AuthHash objects and plain hashes (for testing)
    provider = auth.respond_to?(:provider) ? auth.provider : auth[:provider]
    uid = auth.respond_to?(:uid) ? auth.uid : auth[:uid]
    info = auth.respond_to?(:info) ? auth.info : auth[:info]

    where(provider: provider, uid: uid).first_or_create do |user|
      user.email = info[:email] || info["email"]
      user.first_name = info[:first_name] || info["first_name"] || info[:name]&.split&.first || info["name"]&.split&.first
      user.last_name = info[:last_name] || info["last_name"] || info[:name]&.split&.last || info["name"]&.split&.last
      user.confirmed_at = Time.current
      user.provider_data = auth.respond_to?(:to_h) ? auth.to_h : auth
    end
  end

  # Display helpers
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    full_name.present? ? full_name : email
  end

  private

  def normalize_email
    self.email = email&.downcase&.strip
  end

  def generate_confirmation_token
    self.confirmation_token = generate_token
    self.confirmation_sent_at = Time.current
  end

  def generate_token
    SecureRandom.urlsafe_base64(32)
  end

  def mark_otp_used!
    update!(otp_used_at: Time.current)
  end

  def increment_otp_attempts!
    self.otp_attempts_count += 1
    if otp_attempts_count >= auth_config[:otp_max_attempts]
      self.otp_locked_until = Time.current + auth_config[:otp_lockout_duration]
    end
    save!
  end

  def update_login_tracking!
    update!(
      last_login_at: Time.current,
      failed_login_attempts: 0,
      locked_until: nil
    )
  end

  def secure_compare(a, b)
    return false if a.nil? || b.nil?
    ActiveSupport::SecurityUtils.secure_compare(a, b)
  end
end
