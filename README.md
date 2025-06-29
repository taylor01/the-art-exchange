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
- `image_processing` for photo resizing and variants
- `pg_search` for full-text search
- `tailwindcss-rails` for styling
- `kamal` for deployment

### System Requirements

#### Image Processing (libvips)
The application requires **libvips** for Active Storage image variant processing:

```bash
# macOS (development)
brew install vips

# Ubuntu/Debian (production)
apt-get update && apt-get install -y libvips-dev

# RHEL/CentOS/Amazon Linux (production)
yum install -y vips-devel

# Alpine Linux (Docker)
apk add --no-cache vips-dev
```

**Important**: Without libvips, image optimization will gracefully degrade to serving original images, resulting in slower page loads and higher bandwidth usage. See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed production setup instructions.

## Development Phases

### Phase 1: Foundation (Current)
- [x] Project planning and architecture
- [x] Rails 8 application setup
- [x] OTP + Omniauth authentication system
- [x] Core models: Users, Venues, Artists, Posters, Series ✅ **Issue #5 Complete**
- [ ] User collections and image management ⚡ **Issue #6 Next**
- [ ] Basic admin interface for poster management
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

## Data Migration ✅ COMPLETED

**Migration Status**: Successfully completed 2025-06-29 with 100% success rate.

### Production Migration Results
- ✅ **Users**: 345/346 migrated (99.7% success)
- ✅ **Venues**: 208/208 migrated (100% success)
- ✅ **Artists**: 68/68 migrated (100% success)
- ✅ **Bands**: 14/14 migrated (100% success)
- ✅ **Series**: 19/19 migrated (100% success)
- ✅ **Posters**: 773/773 migrated (100% success)
- ✅ **Images**: 772/773 poster images migrated (99.9% success)
- ✅ **User Collections**: 374/375 migrated (99.7% success)

### Image Migration Innovation
The production image migration used a two-phase approach:
1. **Extract original blob keys** from legacy database backup
2. **Direct S3-to-S3 transfer** using original blob keys (not development keys)
3. **Active Storage integration** with automatic variant generation

**Total Data Transferred**: 471.71 MB of poster images
**Migration Performance**: Zero failures, zero missing S3 objects

For complete migration documentation, see [MIGRATION.md](MIGRATION.md).

## Development Setup

### Prerequisites

Before running the application, install required system dependencies:

```bash
# Install libvips for image processing
brew install vips

# Install other dependencies
bundle install
```

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

## Poster Visual Metadata System

The application includes an AI-powered visual metadata analysis system using Claude Vision API to automatically extract structured data from poster images.

### Metadata Schema Version 1.0

The system generates structured JSON metadata with the following categories:

```json
{
  "visual": {
    "color_palette": ["yellow", "red", "black"],
    "dominant_colors": ["#ffff00", "#ff0000", "#000000"],
    "art_style": "graphic_design",
    "composition": "centered_text",
    "complexity": "moderate",
    "text_density": "heavy"
  },
  "thematic": {
    "primary_themes": ["entertainment", "music"],
    "mood": ["energetic", "vibrant"],
    "elements": ["signage", "typography"],
    "genre": "music_poster"
  },
  "technical": {
    "layout": "landscape",
    "typography_style": "bold_vintage",
    "design_era": "contemporary",
    "print_quality_indicators": ["high_resolution", "clear_text"]
  },
  "collectibility": {
    "visual_rarity": "uncommon_style",
    "artistic_significance": "medium",
    "design_complexity": "medium",
    "iconic_elements": ["musician_image", "venue_name"]
  },
  "market_appeal": {
    "demographic_appeal": ["music_fans", "event_attendees"],
    "display_context": ["concert_venue", "promotional"],
    "frame_compatibility": "medium",
    "wall_color_match": ["yellow", "red"]
  }
}
```

### Metadata Analysis Commands

```bash
# Analyze a specific poster by ID
rake "posters:analyze[1380]"

# Show metadata for a poster
rake "posters:show_metadata[1380]"

# Analyze all posters with images (background jobs)
rake posters:analyze_all

# Re-analyze posters with outdated metadata versions
rake posters:analyze_outdated

# Force re-analyze a specific poster to current version
rake "posters:reanalyze[1380]"

# Show statistics including version information
rake posters:stats
```

### Metadata Versioning System

The system tracks metadata schema versions to enable future format updates without losing existing data.

#### Version Management

Each poster's metadata includes a `metadata_version` field that tracks which schema version was used for analysis. The current version is defined as:

```ruby
# In app/services/poster_metadata_service.rb
CURRENT_METADATA_VERSION = "1.0"
```

#### Poster Model Methods

```ruby
poster.metadata_version_current?    # true if version matches current
poster.metadata_version_outdated?   # true if has metadata but old version
poster.metadata_version_missing?    # true if has metadata but no version
poster.needs_reanalysis?           # true if poster needs re-analysis
```

#### Updating Metadata Schema (Future)

When you need to change the metadata format:

1. **Update the analysis prompt** in `PosterMetadataService#claude_analysis_prompt`
2. **Increment the version number**:
   ```ruby
   CURRENT_METADATA_VERSION = "1.1"  # Increment version
   ```
3. **Add new fields to the prompt**:
   ```ruby
   "market_appeal": {
     "demographic_appeal": ["demographic1", "demographic2"],
     "display_context": ["context1", "context2"], 
     "frame_compatibility": "low|medium|high",
     "wall_color_match": ["color1", "color2"],
     "wall_color_complementary": ["color1", "color2", "color3"]  # New field
   }
   ```
4. **Re-analyze outdated posters**:
   ```bash
   rake posters:analyze_outdated
   ```
5. **Monitor progress**:
   ```bash
   rake posters:stats
   ```

#### Version Statistics

```bash
$ rake posters:stats
📊 Metadata Statistics:
   Total posters with images: 772
   Analyzed posters: 150
   Current version (1.0): 145
   Outdated/missing version: 5
```

#### Benefits of Versioned Metadata

- **Selective re-analysis**: Only update posters that need it
- **Cost control**: Avoid unnecessary API calls to current posters  
- **Historical tracking**: Know which version was used for each poster
- **Quality assurance**: Ensure consistent metadata across collection
- **Future-proofing**: Easy schema evolution as requirements change

### Environment Setup

The metadata system requires the Anthropic API key to be set:

```bash
# In your .env file
ANTHROPIC_API_KEY=your_api_key_here
```

The system uses Claude Haiku model for cost-effective analysis while maintaining good quality results. Images are automatically resized to 1500px maximum for optimal API performance.

## Development Status

🎯 **Phase 1 Development** - Core models and authentication complete. Ready for UI development.

### Current Status
- ✅ **Issue #5: Core Models** - Complete database foundation with 224 passing tests
- ⚡ **Issue #6: User Collections & Image Management** - Next priority
- 🔍 **Full-text search** implemented across all models via pg_search
- 🔐 **Authentication** working (login, logout, profile management)
- 🧪 **Test coverage** 100% for all models with comprehensive factories

### Database Models Implemented
- **User**: Enhanced with collector profiles, contact preferences, social media
- **Venue**: International addressing, geocoding, duplicate detection  
- **Artist**: Poster creators with search functionality
- **Band**: Musical performers with unique names
- **Series**: Related poster collections (e.g., "Playing Card Series")
- **Poster**: Complete model with artist collaboration and series support

### Next Steps (Issue #6)
- Build poster management UI (add/edit/view posters)
- Implement image upload system for poster photos
- Create collection management interface
- Add poster browsing and discovery pages