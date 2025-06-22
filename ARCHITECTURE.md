# The Art Exchange - Architecture Plan

## Database Schema Design

### Core Models

#### Users
- `id` (primary key)
- `email` (unique, required)
- `encrypted_password` (optional for OTP-only users)
- `first_name`, `last_name`
- `profile_image_url`
- `confirmed_at` (email confirmation)
- `reset_password_token`, `reset_password_sent_at`
- `otp_secret_key` (for one-time passwords)
- `provider`, `uid` (for Omniauth)
- `created_at`, `updated_at`

#### Venues
- `id` (primary key)
- `name` (required)
- `address`, `city`, `state`, `country`, `postal_code`
- `latitude`, `longitude` (geocoded)
- `website_url`, `phone`
- `description`
- `created_at`, `updated_at`

#### Artists
- `id` (primary key)
- `name` (required)
- `biography`
- `website_url`, `social_media_links` (JSON)
- `profile_image_url`
- `created_at`, `updated_at`

#### Series
- `id` (primary key)
- `name` (required)
- `description`
- `artist_id` (foreign key)
- `created_at`, `updated_at`

#### Posters
- `id` (primary key)
- `title` (required)
- `artist_id` (foreign key)
- `venue_id` (foreign key, optional)
- `series_id` (foreign key, optional)
- `event_date`
- `poster_year`
- `dimensions` (e.g., "18x24")
- `edition_size` (total print run)
- `poster_type` (screen print, offset, etc.)
- `official_image_url`
- `description`
- `created_at`, `updated_at`

#### Collections (User's Poster Ownership)
- `id` (primary key)
- `user_id` (foreign key)
- `poster_id` (foreign key)
- `condition` (mint, near mint, good, fair, poor)
- `purchase_price` (decimal)
- `purchase_date`
- `print_number` (e.g., "42/100")
- `notes` (text)
- `created_at`, `updated_at`

#### Collection Images (User's Poster Photos)
- `id` (primary key)
- `collection_id` (foreign key)
- `image_url` (required)
- `caption`
- `is_primary` (boolean)
- `created_at`, `updated_at`

## Authentication Strategy

### Primary Authentication
- Email/password with Devise as foundation
- Email confirmation required
- Secure password reset flow

### Alternative Login Methods
- One-time password via email (passwordless)
- Omniauth providers: Google, Apple, Facebook
- Session management with secure cookies

### Security Features
- Rate limiting on authentication attempts
- Strong password requirements (when used)
- Secure token generation for OTP
- CSRF protection
- XSS prevention

## Application Architecture

### Rails 8 Features to Leverage
- **Stimulus**: Interactive UI components
- **Turbo**: Fast page transitions and updates
- **Hotwire**: Real-time updates
- **Action Cable**: WebSocket connections (future notifications)
- **Active Storage**: Image uploads and processing
- **Active Job**: Background processing

### Key Gems/Dependencies
- `omniauth` + provider gems
- `geocoder` for address geocoding
- `image_processing` for photo handling
- `redis` for caching and sessions
- `sidekiq` for background jobs
- `rspec-rails` for testing

### File Structure
```
/app
  /controllers
    /auth (authentication controllers)
    /collections (user collection management)
    /posters (poster catalog)
  /models
    user.rb
    venue.rb, artist.rb, poster.rb
    collection.rb, collection_image.rb
  /views
    /layouts
    /shared (components)
    /collections
    /posters
  /javascript
    /controllers (Stimulus)
  /stylesheets
    application.css
/config
  /initializers
    omniauth.rb
    geocoder.rb
/db
  /migrate
  /seeds
```

### Security Considerations
- Input validation and sanitization
- File upload restrictions and scanning
- Privacy controls for collections
- Rate limiting on API endpoints
- Secure session management
- HTTPS enforcement in production

## Development Phases

### Phase 1: Foundation
- Rails 8 application setup
- Authentication system implementation
- Basic user management

### Phase 2: Core Models
- Database schema implementation
- Venue, Artist, Poster models
- Admin interface for data entry

### Phase 3: Collection Management
- User collection functionality
- Image upload and management
- Collection value tracking

### Phase 4: Enhancement
- Advanced search and filtering
- Map integration for venues
- Social features and sharing