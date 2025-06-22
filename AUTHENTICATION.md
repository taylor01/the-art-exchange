# Authentication System Documentation

The Art Exchange uses a modern, secure authentication system with OTP (One-Time Password) as the primary method and traditional passwords as a backup option.

## Features

### Core Authentication Methods
- **OTP-first authentication**: Passwordless login via email verification codes
- **Traditional password authentication**: Optional backup authentication method
- **Social login**: OAuth integration with Google, Apple, and Facebook
- **Email verification**: Required for all account creation methods

### Security Features
- **Account lockout**: Automatic lockout after failed attempts
- **Rate limiting**: Protection against brute force attacks
- **Secure token generation**: Cryptographically secure tokens for all authentication flows
- **Configurable timeouts**: Environment-specific timeout values
- **CSRF protection**: Built-in protection against cross-site request forgery
- **Security headers**: Comprehensive HTTP security headers

## Authentication Flow

### User Registration
1. User provides email, first name, last name, and optional password
2. System generates confirmation token and sends email
3. User clicks confirmation link to activate account
4. Account becomes active and confirmed

### OTP Login (Primary)
1. User enters email address
2. System generates secure OTP token and sends via email
3. User enters OTP code from email
4. System validates token and creates session
5. User is signed in

### Password Login (Backup)
1. User enters email and selects password option
2. User provides password
3. System validates credentials
4. User is signed in (if account not locked)

### Social Login (OAuth)
1. User clicks social provider button
2. Redirected to provider (Google/Apple/Facebook)
3. User authorizes application
4. System receives user data and creates/finds account
5. User is automatically signed in

## Configuration

Authentication settings are configurable in `config/initializers/authentication.rb`:

```ruby
Rails.application.configure do
  config.authentication = {
    # OTP settings
    otp_expires_in: Rails.env.production? ? 10.minutes : 30.minutes,
    otp_max_attempts: 3,
    otp_lockout_duration: Rails.env.production? ? 15.minutes : 5.minutes,
    
    # Session settings
    session_timeout: 30.days,
    
    # Account security
    max_failed_login_attempts: 5,
    account_lockout_duration: 30.minutes,
    
    # Email verification
    email_verification_expires_in: 24.hours,
    
    # Password requirements
    password_min_length: 8
  }
end
```

## Email Configuration

The system uses Mailgun for email delivery. Configure the following environment variables:

```bash
MAILGUN_API_KEY=your_mailgun_api_key
MAILGUN_DOMAIN=your_mailgun_domain
```

## OAuth Configuration

Set up OAuth providers with these environment variables:

```bash
# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# Facebook OAuth
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret

# Apple OAuth
APPLE_CLIENT_ID=your_apple_client_id
APPLE_TEAM_ID=your_apple_team_id
APPLE_KEY_ID=your_apple_key_id
APPLE_PRIVATE_KEY=your_apple_private_key
```

## Rate Limiting

The system includes comprehensive rate limiting via Rack::Attack:

- **Authentication attempts**: 5 attempts per IP per hour
- **OTP requests**: 3 requests per email per hour
- **Password resets**: 3 requests per email per hour
- **General requests**: 300 requests per IP per 5 minutes

## Security Headers

The application enforces security headers including:
- Content Security Policy (CSP)
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

## User Profile Management

Users can manage their profiles at `/profile` with the following features:
- Update personal information (name, email)
- Change password
- View account details and login history
- Sign out functionality

## Routes

### Authentication Routes
- `GET /sign_in` - Sign in form
- `POST /sign_in` - Process sign in
- `DELETE /sign_out` - Sign out
- `GET /sign_up` - Registration form
- `POST /sign_up` - Process registration

### OTP Verification
- `GET /verify` - OTP verification form
- `POST /verify` - Verify OTP code
- `POST /verify/resend` - Resend OTP code

### Email Confirmation
- `GET /confirm/:token` - Confirm email address
- `GET /resend_confirmation` - Resend confirmation form
- `POST /resend_confirmation` - Resend confirmation email
- `GET /confirmation_sent` - Confirmation sent page

### Password Reset
- `GET /forgot_password` - Password reset request form
- `POST /forgot_password` - Process reset request
- `GET /reset_password/:token` - Password reset form
- `PATCH /reset_password/:token` - Update password

### OAuth Callbacks
- `GET /auth/:provider/callback` - OAuth callback handler
- `GET /auth/failure` - OAuth failure handler

### User Profile
- `GET /profile` - User profile page
- `GET /profile/edit` - Edit profile form
- `PATCH /profile` - Update profile

## Testing

The authentication system includes comprehensive test coverage:

- **Model tests**: User model with all authentication features
- **Controller tests**: All authentication controllers with edge cases
- **Mailer tests**: Email delivery verification
- **Integration tests**: Complete authentication flows

Run tests with:
```bash
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/controllers/
bundle exec rspec spec/mailers/
```

## Security Considerations

### Data Protection
- Passwords are hashed using bcrypt
- OTP tokens are securely generated and time-limited
- All authentication tokens use secure random generation
- Email addresses are normalized and validated

### Session Management
- Sessions are managed server-side
- Session IDs are regenerated on login
- Sessions expire based on configurable timeouts
- Secure session cookies in production

### Account Security
- Account lockout prevents brute force attacks
- Rate limiting protects against automation
- Email verification prevents account takeover
- Audit trail for security events

## Troubleshooting

### Common Issues

**OTP emails not sending**
- Verify Mailgun configuration
- Check API key and domain settings
- Review email delivery logs

**OAuth provider errors**
- Verify OAuth app configuration
- Check redirect URLs match exactly
- Ensure environment variables are set

**Rate limiting issues**
- Check IP whitelist for development
- Review rate limit configurations
- Monitor attack logs

**Session issues**
- Verify session store configuration
- Check session timeout settings
- Clear browser cookies if needed

### Development Setup

For local development:
1. Set up Mailgun sandbox domain
2. Configure OAuth apps for localhost
3. Use test mode for email delivery
4. Whitelist localhost in rate limiting

## Maintenance

### Regular Tasks
- Monitor authentication logs
- Review rate limiting effectiveness
- Update OAuth provider settings
- Rotate API keys periodically
- Review security headers configuration

### Updates
- Keep OAuth gems updated
- Monitor security advisories
- Test authentication flows after updates
- Review and update security policies