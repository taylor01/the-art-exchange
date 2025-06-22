# The Art Exchange

A modern Rails 8 application for tracking and collecting art posters.

## Overview

The Art Exchange is a community-driven marketplace and collection management platform for art poster enthusiasts. Users can discover artwork, track their collections, and connect with other collectors. The platform will start with ~1000 existing posters and expects a few hundred daily visitors.

## Core Features

### Authentication & User Management
- **One-time password (OTP) primary authentication** - passwordless login via email
- **Social login backup** - Google, Apple, Facebook via Omniauth
- Traditional password option available
- Email verification required for all signup methods
- User profile management with public/private showcase options

### Data Models
- **Venues**: Performance locations with geocoded addresses
- **Artists**: Poster creators and their portfolios  
- **Posters**: Master poster records (admin-managed with official images)
- **Series**: Related poster groupings
- **Collections**: User-owned poster inventories with personal details
- **Collection Images**: User-uploaded photos of their physical posters

### Collection Management
- Add master posters to personal collections
- Track poster condition, purchase price, print numbers
- Upload multiple photos of owned posters (auto-resized)
- **Public showcase** - users select which collection attributes to display publicly
- Value tracking with future AI-powered market valuations

### Future Features (Phase 2+)
- **Social marketplace** - users can list collection items for sale
- **Market valuation API** - AI-powered pricing based on sales data
- **Advanced search** - full-text search with faceted filtering
- **Mobile app** - native iOS/Android applications

## Technical Stack

### Core Technologies
- **Framework**: Rails 8 (traditional app with future API endpoints)
- **Database**: PostgreSQL (Digital Ocean Managed Database)
- **Frontend**: Tailwind CSS + Stimulus + Turbo
- **Authentication**: Custom OTP + Omniauth
- **Image Storage**: Active Storage with S3
- **Search**: PostgreSQL full-text search (pg_search gem)
- **Geocoding**: Geocoder gem for venue addresses

### Infrastructure
- **Hosting**: Digital Ocean droplets via Kamal deployment
- **Image Storage**: AWS S3 with Active Storage
- **Database**: Digital Ocean Managed PostgreSQL
- **Backups**: Automated daily DB dumps to S3
- **SSL**: Let's Encrypt via Kamal

### Key Dependencies
- `omniauth` + provider gems (Google, Apple, Facebook)
- `geocoder` for address geocoding
- `image_processing` for photo resizing
- `pg_search` for full-text search
- `tailwindcss-rails` for styling
- `kamal` for deployment

## Development Phases

### Phase 1: Foundation (Current)
- [x] Project planning and architecture
- [x] Rails 8 application setup
- [x] OTP + Omniauth authentication system (User model complete, UI pending)
- [ ] Core models: Users, Venues, Artists, Posters, Series
- [ ] Basic admin interface for poster management
- [ ] User collections and image uploads
- [ ] Responsive mobile-first design

### Phase 2: Social Features
- [ ] Public user showcases with privacy controls
- [ ] Collection browsing and discovery
- [ ] User-to-user messaging
- [ ] Enhanced search and filtering

### Phase 3: Marketplace
- [ ] Collection item listing for sale
- [ ] Transaction management
- [ ] AI-powered market valuations
- [ ] Sales analytics and reporting

### Phase 4: Enhancement
- [ ] Native mobile applications
- [ ] Advanced analytics and insights
- [ ] Third-party integrations
- [ ] API for external services

## Security & Privacy

- Rate limiting on authentication attempts
- Secure token generation for OTP
- Image upload validation and scanning
- CSRF and XSS protection
- User-controlled privacy settings for collections
- HTTPS enforcement
- Regular automated backups

## Data Migration

The application will import existing data:
- ~1000 poster records from current system
- Venue and artist information
- Existing user accounts (with re-verification required)

## Development Commands

### Pre-Commit Checks
```bash
# Run all development checks (recommended before commits)
./bin/checks

# Run security checks only
./bin/checks security

# Run quick checks (linting + tests)
./bin/checks quick
```

### Individual Commands
```bash
# Start development server
./bin/dev

# Run tests
bundle exec rspec

# Security scans
bundle exec brakeman
bundle exec bundler-audit check --update

# Code linting
bundle exec rubocop
```

## Development Status

🚧 **Phase 1 Development** - Rails 8 application setup complete with security tooling.