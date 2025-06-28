# Application Architecture

## Overview

The Art Exchange is built on **Rails 8** with a modern, scalable architecture designed for performance, maintainability, and future growth. This page provides a comprehensive technical overview of the system design, data models, and technology choices.

*For complete details, see [ARCHITECTURE.md](../blob/main/ARCHITECTURE.md) in the repository.*

## Technology Stack

### Core Framework
- **Rails 8**: Latest Rails with modern conventions
- **Ruby 3.3.0**: Current stable Ruby version
- **PostgreSQL 14+**: Primary database with full-text search
- **Hotwire**: Turbo + Stimulus for reactive UI without JavaScript frameworks

### Frontend Technologies
- **Tailwind CSS**: Utility-first CSS framework
- **Stimulus**: JavaScript framework for enhanced interactions
- **Turbo**: SPA-like navigation without complexity
- **ERB Templates**: Server-rendered HTML views

### Storage & Assets
- **Active Storage**: File uploads and image management
- **AWS S3**: Production image storage with signed URLs
- **libvips**: High-performance image processing
- **Image Variants**: Multiple sizes with progressive loading

### Authentication & Security
- **OTP (One-Time Password)**: Passwordless authentication (primary)
- **Omniauth**: OAuth integration (Google, Apple, Facebook)
- **BCrypt**: Traditional password hashing (fallback)
- **CSRF Protection**: Rails built-in security
- **Rate Limiting**: Authentication attempt protection

### AI & Machine Learning
- **Anthropic Claude API**: Visual poster metadata analysis
- **JSON Storage**: Versioned metadata with future schema support
- **Batch Processing**: Rake tasks for bulk analysis

### Background Processing
- **Solid Queue**: Rails 8 background job processing
- **Action Mailer**: Email delivery with OTP codes
- **Rake Tasks**: Data migration and maintenance

## Database Architecture

### Core Models Relationship

```
Users (773+ in production)
├── UserPosters (Collection Management)
│   ├── owned/wanted/watching status
│   ├── condition tracking
│   ├── price tracking
│   └── personal notes
├── SearchAnalytics (User behavior)
└── Shares (Social features)

Posters (773+ in production, 2000+ images)
├── Artists (many-to-many collaboration)
├── Venues (performance locations)
├── Bands (musical performers)
├── Series (related poster collections)
├── UserPosters (collection relationships)
└── VisualMetadata (AI-generated analysis)

Geographic Data
├── Venues with international addressing
├── Geocoder integration
└── Duplicate venue detection
```

### Key Database Features

#### Search Infrastructure
```ruby
# PostgreSQL full-text search via pg_search
include PgSearch::Model

pg_search_scope :search_all,
  against: [:title, :description],
  associated_against: {
    artists: [:name],
    venue: [:name, :city],
    band: [:name]
  },
  using: {
    tsearch: { prefix: true, highlight: true }
  }
```

#### Visual Metadata System
```ruby
# JSON column for AI-generated poster analysis
add_column :posters, :visual_metadata, :json

# Structured metadata format
{
  "visual": {
    "color_palette": ["black", "white", "blue"],
    "dominant_colors": ["#000000", "#ffffff", "#4a90e2"],
    "art_style": "minimalist",
    "composition": "centered_focal_point"
  },
  "thematic": {
    "primary_themes": ["celestial", "night_sky"],
    "mood": ["peaceful", "dreamy"],
    "elements": ["moon", "clouds", "stars"]
  },
  "technical": {
    "layout": "portrait",
    "typography_style": "modern_sans_serif",
    "design_era": "contemporary"
  },
  "collectibility": {
    "visual_rarity": "common_style",
    "artistic_significance": "medium"
  },
  "market_appeal": {
    "demographic_appeal": ["millennials", "music_fans"],
    "display_context": ["bedroom", "office"]
  }
}
```

## Application Layers

### 1. Presentation Layer (Views)
```
app/views/
├── layouts/
│   ├── application.html.erb (main layout)
│   └── _header.html.erb (navigation)
├── posters/
│   ├── index.html.erb (browsing with search)
│   └── show.html.erb (detailed view)
├── user_posters/
│   └── index.html.erb (collection dashboard)
└── admin/
    └── posters/ (CRUD interface)
```

### 2. Controller Layer
```
app/controllers/
├── application_controller.rb (base authentication)
├── posters_controller.rb (public browsing)
├── user_posters_controller.rb (collection management)
├── admin/
│   └── posters_controller.rb (admin CRUD)
└── sessions_controller.rb (OTP authentication)
```

### 3. Model Layer
```
app/models/
├── user.rb (authentication + collector profile)
├── poster.rb (artwork with metadata)
├── artist.rb (poster creators)
├── venue.rb (locations with geocoding)
├── band.rb (musical performers)
├── series.rb (poster collections)
└── user_poster.rb (collection relationships)
```

### 4. Service Layer
```
app/services/
├── poster_metadata_service.rb (AI analysis)
├── anthropic_service.rb (Claude API integration)
└── geocoding_service.rb (venue location)
```

## Image Processing Pipeline

### Upload Flow
1. **User Upload**: Active Storage direct upload
2. **Processing**: libvips generates multiple variants
3. **Storage**: AWS S3 with private bucket + signed URLs
4. **Display**: Progressive loading with blur-up effect

### Image Variants
```ruby
# config/application.rb
config.active_storage.variant_processor = :vips

# Generated variants
poster.images.variant(resize: "300x400>") # Thumbnail
poster.images.variant(resize: "600x800>") # Medium
poster.images.variant(resize: "1200x1600>") # Large
```

### Security Model
- **Private S3 Bucket**: No public access
- **Signed URLs**: Time-limited access (15 minutes)
- **CSRF Protection**: All form submissions
- **Rate Limiting**: Authentication endpoints

## API Architecture (Planned)

### Current State
- **Web Application**: Server-rendered with Hotwire
- **Internal APIs**: JSON responses for AJAX interactions
- **Admin Interface**: Web-based CRUD operations

### Future API Strategy (Phases 2-3)
```ruby
# Planned RESTful API structure
/api/v1/
├── posters (public read, admin write)
├── collections (user-specific)
├── search (enhanced filtering)
├── metadata (AI analysis results)
└── marketplace (Phase 3 - transactions)
```

## Performance Considerations

### Database Optimization
- **Indexes**: Strategic indexing on search fields
- **Eager Loading**: Prevents N+1 queries
- **Full-text Search**: PostgreSQL built-in search
- **Connection Pooling**: Rails connection management

### Caching Strategy
- **Fragment Caching**: Poster cards and metadata
- **Asset Caching**: Fingerprinted static assets
- **HTTP Caching**: Appropriate cache headers
- **Image CDN**: S3 CloudFront distribution (planned)

### Monitoring & Observability
- **Rails Logs**: Structured logging for debugging
- **Performance Metrics**: Built-in Rails insights
- **Error Tracking**: Exception notification
- **Database Queries**: Development query analysis

## Security Architecture

### Authentication Flow
```
1. User enters email
2. OTP code generated and emailed
3. User enters OTP code
4. Session established with secure cookies
5. Optional: OAuth fallback for social login
```

### Data Protection
- **Encrypted Passwords**: BCrypt hashing
- **Secure Sessions**: HttpOnly, Secure cookies
- **SQL Injection**: Rails parameter binding
- **XSS Protection**: ERB auto-escaping
- **CSRF Tokens**: Rails built-in protection

### Security Scanning
```bash
# Automated security checks
bundle exec brakeman     # Static analysis
bundle exec bundle-audit # Dependency vulnerabilities
```

## Deployment Architecture

### Production Environment
- **Platform**: Heroku with Kamal deployment
- **Database**: Heroku Postgres (or DigitalOcean Managed)
- **File Storage**: AWS S3 with CloudFront
- **SSL**: Let's Encrypt via Kamal
- **Background Jobs**: Solid Queue in Puma process

### Environment Configuration
```bash
# Required environment variables
DATABASE_URL              # PostgreSQL connection
ANTHROPIC_API_KEY        # Claude API access
AWS_ACCESS_KEY_ID        # S3 storage
AWS_SECRET_ACCESS_KEY    # S3 credentials
AWS_BUCKET               # S3 bucket name
AWS_REGION               # S3 region

# OAuth credentials (optional)
GOOGLE_CLIENT_ID
FACEBOOK_APP_ID
APPLE_CLIENT_ID
```

## Data Migration Strategy

### Legacy System Integration
- **Source**: Existing theartexch.com Rails application
- **Data Volume**: 773 artworks, ~750 users, ~2000 images
- **Migration Approach**: Phased with validation and rollback
- **Success Rate**: 99.9% based on previous attempts

### Migration Pipeline
```ruby
# Production migration tasks
rake production:migrate_users     # User accounts
rake production:migrate_posters   # Artwork data
rake production:migrate_images    # S3 image transfer
rake production:validate_migration # Data integrity checks
```

## Testing Architecture

### Test Coverage
- **Total Tests**: 345+ passing tests
- **Model Tests**: 188 unit tests (100% coverage)
- **System Tests**: 37 integration tests
- **Request Tests**: API endpoint coverage
- **Security Tests**: Brakeman integration

### Testing Stack
```ruby
# Test framework
RSpec                    # Primary testing framework
FactoryBot              # Test data generation
Capybara + Selenium     # Browser integration tests
Database Cleaner        # Test database cleanup
SimpleCov               # Coverage reporting
```

## Development Tools

### Code Quality
```ruby
# Linting and standards
RuboCop                 # Rails Omakase configuration
Brakeman               # Security static analysis
Bundle Audit           # Dependency security
```

### Development Workflow
```bash
# Quality check script
./bin/checks            # Runs all quality checks
bundle exec rspec       # Full test suite
bundle exec rubocop     # Code linting
bundle exec brakeman    # Security scan
```

## Future Architecture Considerations

### Scalability Planning
- **Database Sharding**: User-based partitioning for large datasets
- **Microservices**: Extract AI service for independent scaling
- **CDN Integration**: Global image delivery optimization
- **Caching Layers**: Redis for session and fragment caching

### Technology Evolution
- **ViewComponent**: Component-based view architecture
- **Hotwire Native**: Mobile app development
- **GraphQL**: Flexible API queries for mobile
- **Machine Learning**: Enhanced recommendation engine

---

*For implementation details and current status, see the main [ARCHITECTURE.md](../blob/main/ARCHITECTURE.md) file.*