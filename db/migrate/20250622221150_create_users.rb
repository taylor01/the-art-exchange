class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name

      # Email confirmation
      t.datetime :confirmed_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at

      # OTP authentication
      t.string :otp_secret_key
      t.datetime :otp_sent_at
      t.datetime :otp_used_at
      t.integer :otp_attempts_count, default: 0
      t.datetime :otp_locked_until

      # Optional password authentication
      t.string :password_digest

      # Password reset
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # Account security
      t.integer :failed_login_attempts, default: 0
      t.datetime :locked_until
      t.datetime :last_login_at

      # Omniauth fields
      t.string :provider
      t.string :uid
      t.json :provider_data

      # Profile settings
      t.boolean :admin, default: false
      t.json :showcase_settings, default: {}

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, [ :provider, :uid ], unique: true
    add_index :users, :otp_secret_key, unique: true
  end
end
