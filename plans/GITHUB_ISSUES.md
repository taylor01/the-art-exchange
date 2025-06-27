# GitHub Issues for DMB Setlist Integration

Copy-paste each issue below into GitHub with the specified labels and settings.

---

## Issue #64: Database Schema for Shows and Setlists

**Labels**: `feature`, `phase-1`, `backend`, `database`  
**Priority**: High  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 1 - Foundation

### Description

Create comprehensive database schema for shows, songs, albums, and setlist relationships to support the DMB setlist integration project.

### Acceptance Criteria

- [ ] Create comprehensive database schema for shows, songs, and setlist relationships
- [ ] All tables have proper indexes for performance
- [ ] Foreign key constraints maintain data integrity
- [ ] Schema supports multiple bands (not just DMB)
- [ ] Migration runs successfully in all environments

### Tasks

#### Database Migrations

- [ ] **Create `shows` table migration**
  - `band_id` (foreign key to bands)
  - `venue_id` (foreign key to venues)
  - `show_date` (date, required)
  - `show_notes` (text, optional)
  - `scraped_at` (timestamp)
  - `slug` (string, unique, for URLs)
  - Unique constraint on `band_id + venue_id + show_date`
  
- [ ] **Create `songs` table migration**
  - `title` (string, required)
  - `artist_credit` (string, optional - for guest performances)
  - `slug` (string, unique, for URLs)
  - `is_cover_song` (boolean, default false)
  - `original_artist` (string, optional)
  - `first_performed_at` (date, optional)
  - `musicbrainz_id` (string, optional, indexed)
  - `spotify_id` (string, optional, indexed)
  - `audio_features` (json, optional)

- [ ] **Create `albums` table migration**
  - `title` (string, required)
  - `band_id` (foreign key to bands)
  - `release_date` (date, optional)
  - `album_type` (enum: studio/live/compilation/single)
  - `musicbrainz_id` (string, optional, indexed)
  - `spotify_id` (string, optional, indexed)

- [ ] **Create `album_songs` table migration**
  - `album_id` (foreign key to albums)
  - `song_id` (foreign key to songs)
  - `track_number` (integer, optional)
  - `disc_number` (integer, optional, default 1)
  - Unique constraint on `album_id + song_id`

- [ ] **Create `setlist_songs` table migration**
  - `show_id` (foreign key to shows)
  - `song_id` (foreign key to songs)
  - `set_type` (enum: main_set/encore)
  - `position` (integer, required)
  - `notes` (json array for guests, segues, special performances)
  - Unique constraint on `show_id + set_type + position`

- [ ] **Add `show_id` to posters table**
  - Optional foreign key to link posters to specific shows
  - Index on `show_id` for performance

#### Testing Requirements

- [ ] **Unit Tests**
  - Model validations for all new models
  - Association tests (belongs_to, has_many relationships)
  - Uniqueness constraint tests
  - Enum value tests for set_type and album_type

- [ ] **Migration Tests**
  - All migrations run successfully forward and backward
  - Foreign key constraints work correctly
  - Indexes are created properly
  - Data integrity maintained during rollback

### Technical Notes

This schema is designed to be extensible beyond DMB and will support the full setlist integration project including album metadata and audio features in future phases.

---

## Issue #65: Core Models with Associations and Validations

**Labels**: `feature`, `phase-1`, `backend`  
**Priority**: High  
**Estimated Effort**: 2-3 days  
**Milestone**: Phase 1 - Foundation  
**Depends on**: #64

### Description

Create all new models with comprehensive associations, validations, and helper methods to support the setlist integration features.

### Acceptance Criteria

- [ ] All new models have comprehensive associations
- [ ] Validation rules ensure data integrity
- [ ] Models include helpful query scopes
- [ ] Slug generation works for URLs
- [ ] Models support search functionality

### Tasks

#### Model Creation

- [ ] **Create Show model** (`app/models/show.rb`)
  - Associations: `belongs_to :band`, `belongs_to :venue`, `has_many :setlist_songs`, `has_many :songs, through: :setlist_songs`, `has_many :posters`
  - Validations: presence of band, venue, show_date; uniqueness of band+venue+date combination
  - Scopes: `by_year`, `by_venue`, `by_band`, `chronological`, `recent`
  - Slug generation from band-venue-date
  - Methods: `display_name`, `formatted_date`, `total_songs`, `encore_songs`

- [ ] **Create Song model** (`app/models/song.rb`)
  - Associations: `has_many :setlist_songs`, `has_many :shows, through: :setlist_songs`, `has_and_belongs_to_many :albums`
  - Validations: presence of title, uniqueness of title (case insensitive)
  - Scopes: `covers`, `originals`, `frequently_played`, `rarely_played`, `by_first_performance`
  - Search: pg_search integration for title and artist_credit
  - Methods: `is_cover?`, `performance_count`, `last_performed_at`, `debut_show`

- [ ] **Create Album model** (`app/models/album.rb`)
  - Associations: `belongs_to :band`, `has_and_belongs_to_many :songs`
  - Validations: presence of title and band, uniqueness of title per band
  - Scopes: `studio_albums`, `live_albums`, `by_release_date`, `by_band`
  - Methods: `track_count`, `release_year`, `album_type_display`

- [ ] **Create SetlistSong model** (`app/models/setlist_song.rb`)
  - Associations: `belongs_to :show`, `belongs_to :song`
  - Validations: presence of show, song, set_type, position; uniqueness of position within set_type per show
  - Scopes: `main_set`, `encore`, `with_guests`, `with_notes`
  - Methods: `has_guests?`, `has_segue?`, `special_performance?`

- [ ] **Update Poster model** (`app/models/poster.rb`)
  - Add association: `belongs_to :show, optional: true`
  - Add method: `has_setlist?` to check if poster has associated show data
  - Update display methods to include show information when available

#### Testing Requirements

- [ ] **Model Tests** (`spec/models/`)
  - Association tests for all relationships
  - Validation tests for all rules
  - Scope tests return correct records
  - Method tests for custom functionality
  - Slug generation tests
  - Search functionality tests

- [ ] **Integration Tests**
  - Cross-model queries work efficiently
  - Dependent destroy behavior works correctly
  - Optional associations handle nil gracefully

### Technical Notes

All models should follow existing application conventions and include comprehensive test coverage.

---

## Issue #66: Setlist JSON Import System

**Labels**: `feature`, `phase-1`, `backend`  
**Priority**: High  
**Estimated Effort**: 4-5 days  
**Milestone**: Phase 1 - Foundation  
**Depends on**: #65

### Description

Create a robust import system to process all 1,084 DMB setlist JSON files and populate the database with shows, songs, and setlist data.

### Acceptance Criteria

- [ ] Rake task imports all 1,084 setlist JSON files successfully
- [ ] Venue matching/creation works for all locations
- [ ] Song deduplication handles variations and typos
- [ ] Show records are created with proper associations
- [ ] Import is idempotent (can be run multiple times safely)
- [ ] Progress reporting and error handling

### Tasks

#### Service Classes

- [ ] **Create SetlistImportService** (`app/services/setlist_import_service.rb`)
  - Parse JSON files and extract show data
  - Match venues by name and location (fuzzy matching)
  - Create new venues for unmatched locations
  - Deduplicate songs by title (handle variations like "Song Title *", "Song Title [Dave Solo]")
  - Create show records with proper slug generation
  - Handle guest performances and special notes

- [ ] **Create VenueMatchingService** (`app/services/venue_matching_service.rb`)
  - Fuzzy string matching for venue names
  - Location-based matching (city, state)
  - Handle venue name variations and abbreviations
  - Create new venue records with geocoding
  - Update venue previous_names array for future matching

- [ ] **Create SongDeduplicationService** (`app/services/song_deduplication_service.rb`)
  - Normalize song titles (remove special characters, brackets, etc.)
  - Handle common variations and abbreviations
  - Identify cover songs from context
  - Maintain original title format while creating normalized lookup

#### Rake Tasks

- [ ] **Create rake task: `setlists:import`** (`lib/tasks/setlists.rake`)
  - Process all JSON files in tools/dmb_scraper/setlists
  - Show progress bar and statistics
  - Error logging with file-specific details
  - Rollback capability for failed imports
  - Option to import specific date ranges

- [ ] **Create rake task: `setlists:validate`** (`lib/tasks/setlists.rake`)
  - Check data integrity after import
  - Report missing venues or unmatched songs
  - Validate setlist ordering and completeness
  - Generate import statistics and summary report

#### Testing Requirements

- [ ] **Service Tests** (`spec/services/`)
  - Test with sample JSON files
  - Venue matching accuracy tests
  - Song deduplication correctness tests
  - Error handling for malformed data
  - Idempotency tests (running import twice)

- [ ] **Integration Tests**
  - Full import process with test data
  - Database state validation after import
  - Performance tests with large datasets
  - Memory usage monitoring during import

### Technical Notes

The import system should be robust enough to handle the full dataset (1,084 files) while providing detailed logging and error recovery capabilities.

---

## Issue #67: Basic Show Pages and Routing

**Labels**: `feature`, `phase-1`, `frontend`  
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 1 - Foundation  
**Depends on**: #66

### Description

Create user-facing show pages with complete setlist displays, browsing capabilities, and responsive design.

### Acceptance Criteria

- [ ] Show pages display complete setlist information
- [ ] Routes follow RESTful conventions with slugs
- [ ] Shows are browsable by year, venue, and band
- [ ] Basic search functionality for shows
- [ ] Mobile-responsive design
- [ ] SEO-friendly URLs and meta tags

### Tasks

#### Controller & Routes

- [ ] **Create ShowsController** (`app/controllers/shows_controller.rb`)
  - `index` action with filtering by year, venue, band
  - `show` action with slug-based lookup
  - Search functionality for show dates and venues
  - Pagination for large result sets
  - JSON API endpoints for future AJAX features

- [ ] **Update routes.rb** (`config/routes.rb`)
  - RESTful show routes with slug parameter
  - Nested routes for band shows and venue shows
  - Search routes with query parameters
  - API namespace for JSON endpoints

#### Views & Templates

- [ ] **Create show views** (`app/views/shows/`)
  - `shows/index.html.erb` - browsable show listing with filters
  - `shows/show.html.erb` - detailed show page with complete setlist
  - Responsive grid layout for show cards
  - Setlist display with main set and encore sections
  - Guest musician highlighting
  - Links to associated posters (if any)

- [ ] **Update navigation** (`app/views/layouts/`)
  - Add "Shows" to main navigation menu
  - Show count in navigation (e.g., "Shows (1,084)")
  - Breadcrumb navigation for show browsing
  - Filter sidebar for show discovery

#### Testing Requirements

- [ ] **Controller Tests** (`spec/controllers/shows_controller_spec.rb`)
  - All actions return correct HTTP status
  - Filtering and search functionality works
  - Pagination works correctly
  - JSON API responses format correctly

- [ ] **View Tests** (`spec/views/shows/`)
  - All show data displays correctly
  - Responsive design works on mobile
  - Links to related content work
  - SEO meta tags are present

- [ ] **System Tests** (`spec/system/shows_spec.rb`)
  - Full user journey from navigation to show details
  - Search and filter interactions
  - Mobile navigation and display
  - Performance with large datasets

### Technical Notes

Follow existing application design patterns and ensure consistency with poster pages.

---

## Issue #68: Poster-Show Linking System

**Labels**: `feature`, `phase-1`, `backend`  
**Priority**: Medium  
**Estimated Effort**: 2-3 days  
**Milestone**: Phase 1 - Foundation  
**Depends on**: #67

### Description

Automatically link existing posters to their corresponding shows and enhance poster pages with setlist information.

### Acceptance Criteria

- [ ] Existing posters automatically link to matching shows
- [ ] Poster show pages display setlist information
- [ ] Unmatched posters and shows are identified
- [ ] Manual linking interface for admin users
- [ ] Historical data integrity maintained

### Tasks

#### Service & Automation

- [ ] **Create PosterShowMatchingService** (`app/services/poster_show_matching_service.rb`)
  - Match posters to shows by band, venue, and date
  - Handle date discrepancies (poster release vs. show date)
  - Fuzzy matching for venue name variations
  - Report unmatched posters and shows for manual review

- [ ] **Create rake task: `posters:link_shows`** (`lib/tasks/posters.rake`)
  - Run automated matching process
  - Generate report of successful and failed matches
  - Option to auto-link high-confidence matches
  - Export unmatched items for manual review

#### Controller Updates

- [ ] **Update PosterController** (`app/controllers/posters_controller.rb`)
  - Display setlist information on poster show pages
  - Link to full show page from poster details
  - Show "No setlist available" state gracefully

- [ ] **Create admin matching interface** (`app/controllers/admin/`)
  - List unmatched posters and shows
  - Manual linking functionality for admin users
  - Bulk operations for common patterns
  - Undo capability for incorrect matches

#### Testing Requirements

- [ ] **Service Tests** (`spec/services/poster_show_matching_service_spec.rb`)
  - Matching accuracy with known poster-show pairs
  - Edge cases (multiple shows same day, venue name changes)
  - Performance with large datasets

- [ ] **Integration Tests**
  - Poster pages display setlist data correctly
  - Admin interface functions properly
  - Automated matching maintains data integrity

### Technical Notes

Maintain data integrity and provide clear audit trails for all automatic and manual linking operations.

---

## Issue #69: MusicBrainz API Integration Service

**Labels**: `feature`, `phase-2`, `backend`  
**Priority**: Medium  
**Estimated Effort**: 4-5 days  
**Milestone**: Phase 2 - Album Integration  
**Depends on**: #68

### Description

Integrate with MusicBrainz API to import comprehensive DMB discography and enhance songs with album information.

### Acceptance Criteria

- [ ] Service integrates with MusicBrainz API
- [ ] DMB discography imported automatically
- [ ] Songs linked to albums with track information
- [ ] Rate limiting and error handling implemented
- [ ] Data caching for performance

### Tasks

#### API Integration

- [ ] **Create MusicBrainzService** (`app/services/musicbrainz_service.rb`)
  - API client with authentication and rate limiting
  - DMB artist lookup using known artist ID: `07e748f1-075e-428d-85dc-ce3be434e706`
  - Release (album) fetching with detailed metadata
  - Recording (song) matching and relationship data
  - Error handling and retry logic for API failures

- [ ] **Create AlbumImportService** (`app/services/album_import_service.rb`)
  - Import all DMB studio albums from MusicBrainz
  - Import live albums and official releases
  - Handle DMB Live Trax series (100+ official bootlegs)
  - Create album-song relationships with track numbers
  - Update existing songs with album information

#### Rake Tasks & Caching

- [ ] **Create rake task: `albums:import_from_musicbrainz`** (`lib/tasks/albums.rake`)
  - Fetch complete DMB discography
  - Match imported songs to existing setlist songs
  - Report unmatched songs and albums
  - Progress tracking and error logging

- [ ] **Implement caching strategy**
  - Cache MusicBrainz API responses locally
  - Periodic cache refresh for updated data
  - Cache invalidation strategies

#### Testing Requirements

- [ ] **API Integration Tests** (`spec/services/musicbrainz_service_spec.rb`)
  - Mock MusicBrainz API responses
  - Rate limiting compliance tests
  - Error handling and retry logic tests
  - Cache functionality tests

- [ ] **Data Quality Tests**
  - Imported album data accuracy
  - Song-album relationship correctness
  - Duplicate detection and handling

### Technical Notes

Follow MusicBrainz API guidelines and implement proper rate limiting to maintain good API citizenship.

---

## Issue #70: Album Model and Song-Album Relationships

**Labels**: `feature`, `phase-2`, `backend`  
**Priority**: Medium  
**Estimated Effort**: 2-3 days  
**Milestone**: Phase 2 - Album Integration  
**Depends on**: #69

### Description

Complete album functionality with full model associations, album browsing, and song-album relationship features.

### Acceptance Criteria

- [ ] Album model fully functional with associations
- [ ] Song-album relationships properly established
- [ ] Album browsing and display functionality
- [ ] Track listing features work correctly

### Tasks

#### Model Enhancement

- [ ] **Enhance Album model** (`app/models/album.rb`)
  - Complete association setup with songs
  - Album artwork support via Active Storage
  - Album statistics (track count, total duration)
  - Search functionality for album titles

#### Views & Controllers

- [ ] **Create album-related views** (`app/views/albums/`)
  - Album index page with filtering
  - Individual album pages with track listings
  - Album artwork display
  - Links from songs to their albums

- [ ] **Update song displays** (`app/views/songs/`)
  - Show album information on song pages
  - "Appears on albums" section for songs
  - Album cover thumbnails in setlists

#### Testing Requirements

- [ ] **Model Tests** (`spec/models/album_spec.rb`)
  - Album-song association tests
  - Album statistics calculation tests
  - Search functionality tests

- [ ] **View Tests** (`app/views/albums/`)
  - Album listing and detail pages
  - Song-album cross-linking
  - Image display and responsiveness

### Technical Notes

Ensure album artwork handling follows existing image management patterns in the application.

---

## Issue #71: Enhanced Show Pages with Album Context

**Labels**: `feature`, `phase-2`, `frontend`  
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 2 - Album Integration  
**Depends on**: #70

### Description

Enhance show pages with rich album context, artwork, and statistical analysis of album representation.

### Acceptance Criteria

- [ ] Show pages display album information for each song
- [ ] Album artwork appears in setlists
- [ ] Show statistics include album distribution
- [ ] Historical context provided for deep cuts and rarities

### Tasks

#### Enhanced Display

- [ ] **Enhance show display views** (`app/views/shows/show.html.erb`)
  - Album information overlay on songs in setlists
  - Album artwork thumbnails for visual appeal
  - "From the album..." contextual information
  - Rarity indicators for seldom-played album tracks

#### Analytics & Insights

- [ ] **Create show analytics** (`app/helpers/shows_helper.rb`)
  - Album distribution charts for shows
  - Era analysis (which albums/periods represented)
  - Deep cuts vs. hits ratio
  - Historical significance indicators

- [ ] **Improve show search and filtering** (`app/controllers/shows_controller.rb`)
  - Filter shows by album representation
  - Search for shows featuring specific albums
  - "Similar shows" recommendations based on setlist content

#### Testing Requirements

- [ ] **Integration Tests** (`spec/system/enhanced_shows_spec.rb`)
  - Album data displays correctly in setlists
  - Show analytics calculate properly
  - Enhanced search functionality works

- [ ] **Performance Tests**
  - Page load times with rich metadata
  - Database query optimization
  - Image loading and caching

### Technical Notes

Focus on visual appeal and information density while maintaining fast page load times.

---

## Issue #72: Cover Song Identification and Metadata

**Labels**: `feature`, `phase-3`, `backend`  
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 3 - Cover Songs & Audio  
**Depends on**: #71

### Description

Automatically identify cover songs and populate original artist information to enhance setlist context.

### Acceptance Criteria

- [ ] Cover songs automatically identified from setlist data
- [ ] Original artist information populated
- [ ] Cover song browsing and statistics
- [ ] Integration with external cover song databases

### Tasks

#### Service Development

- [ ] **Create CoverSongService** (`app/services/cover_song_service.rb`)
  - Identify covers from song titles and setlist context
  - Integrate with SecondHandSongs.com for original artist data
  - Cross-reference with Setlist.fm cover databases
  - Handle common cover variations and alternate titles

#### Model Enhancement

- [ ] **Enhance Song model for covers** (`app/models/song.rb`)
  - Cover song indicators and original artist fields
  - Cover song statistics and first performance tracking
  - Cover browsing by original artist or era

#### Display Features

- [ ] **Create cover song displays** (`app/views/songs/`)
  - Dedicated cover song section
  - Original artist highlighting in setlists
  - Cover song statistics and trends
  - "DMB's interpretation of..." contextual information

#### Testing Requirements

- [ ] **Service Tests** (`spec/services/cover_song_service_spec.rb`)
  - Cover song identification accuracy
  - Original artist data retrieval
  - Edge cases and false positives

- [ ] **Feature Tests** (`spec/system/cover_songs_spec.rb`)
  - Cover song browsing functionality
  - Statistics calculation accuracy
  - Display correctness

### Technical Notes

Balance automatic identification with manual verification to ensure data accuracy.

---

## Issue #73: Spotify API Integration for Audio Features

**Labels**: `feature`, `phase-3`, `backend`  
**Priority**: Medium  
**Estimated Effort**: 4-5 days  
**Milestone**: Phase 3 - Cover Songs & Audio  
**Depends on**: #72

### Description

Integrate with Spotify Web API to import audio features (tempo, energy, danceability) for songs and enable audio-based discovery.

### Acceptance Criteria

- [ ] Songs matched to Spotify tracks
- [ ] Audio features imported (tempo, energy, danceability, etc.)
- [ ] Audio-based show analysis and recommendations
- [ ] Spotify Web API integration with OAuth

### Tasks

#### API Integration

- [ ] **Create SpotifyService** (`app/services/spotify_service.rb`)
  - OAuth integration for Spotify Web API
  - Song matching using artist and title
  - Audio features retrieval and storage
  - Rate limiting and token refresh handling

#### Analysis Services

- [ ] **Create AudioFeaturesService** (`app/services/audio_features_service.rb`)
  - Process and normalize Spotify audio features
  - Calculate show-level audio statistics
  - Generate mood and energy profiles for shows
  - Audio-based similarity algorithms

#### Discovery Features

- [ ] **Create audio-based discovery features** (`app/controllers/shows_controller.rb`)
  - Filter shows by energy, tempo, danceability
  - "Shows like this one" based on audio features
  - Mood-based playlists and recommendations
  - Audio feature visualization

#### Testing Requirements

- [ ] **API Integration Tests** (`spec/services/spotify_service_spec.rb`)
  - Spotify OAuth flow tests
  - Audio features retrieval accuracy
  - Rate limiting compliance

- [ ] **Algorithm Tests** (`spec/services/audio_features_service_spec.rb`)
  - Audio feature calculation correctness
  - Similarity algorithm accuracy
  - Performance with large datasets

### Technical Notes

Implement proper OAuth flow and secure credential storage for Spotify API access.

---

## Issue #74: Advanced Search and Discovery Features

**Labels**: `feature`, `phase-3`, `frontend`  
**Priority**: Low  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 3 - Cover Songs & Audio  
**Depends on**: #73

### Description

Create advanced search capabilities with multi-criteria filtering, audio-based discovery, and recommendation engine.

### Acceptance Criteria

- [ ] Advanced search supports multiple criteria
- [ ] Audio-based filtering and discovery
- [ ] Recommendation engine for shows and songs
- [ ] Saved searches and user preferences

### Tasks

#### Search Interface

- [ ] **Enhanced search interface** (`app/views/search/`)
  - Multi-criteria search (date, venue, songs, album, audio features)
  - Advanced filters with boolean logic
  - Search result sorting and grouping
  - Search history and saved searches

#### Recommendation Engine

- [ ] **Recommendation engine** (`app/services/recommendation_service.rb`)
  - "If you liked this show..." recommendations
  - Similar song identification
  - User preference learning (future enhancement)
  - Discovery suggestions based on listening patterns

#### Audio Discovery

- [ ] **Audio-based discovery** (`app/controllers/discovery_controller.rb`)
  - Mood-based show browsing
  - Energy level filtering
  - Tempo-based recommendations
  - Audio feature visualization charts

#### Testing Requirements

- [ ] **Search Tests** (`spec/system/advanced_search_spec.rb`)
  - Complex query accuracy
  - Performance with large result sets
  - Filter combination logic

- [ ] **Recommendation Tests** (`spec/services/recommendation_service_spec.rb`)
  - Algorithm accuracy validation
  - Performance benchmarks
  - User experience testing

### Technical Notes

Focus on intuitive user interface design while providing powerful search capabilities.

---

## Issue #75: Performance Optimization and Caching

**Labels**: `feature`, `phase-4`, `backend`  
**Priority**: High  
**Estimated Effort**: 2-3 days  
**Milestone**: Phase 4 - Polish & Performance  
**Depends on**: #74

### Description

Optimize application performance with proper indexing, caching strategies, and query optimization for large datasets.

### Acceptance Criteria

- [ ] Page load times under 2 seconds for show pages
- [ ] Database queries optimized with proper indexing
- [ ] Caching strategy implemented for frequently accessed data
- [ ] Memory usage optimized for large datasets

### Tasks

#### Database Optimization

- [ ] **Database optimization**
  - Add missing indexes for common queries
  - Optimize N+1 queries with includes/preload
  - Database query analysis and tuning
  - Connection pooling optimization

#### Caching Implementation

- [ ] **Implement caching layers**
  - Page-level caching for show pages
  - Fragment caching for setlists and song data
  - API response caching for external services
  - Cache invalidation strategies

#### Monitoring

- [ ] **Performance monitoring**
  - Query performance monitoring
  - Page load time tracking
  - Memory usage monitoring
  - Error rate tracking

#### Testing Requirements

- [ ] **Performance Tests** (`spec/performance/`)
  - Load testing with realistic data volumes
  - Database query performance benchmarks
  - Cache hit rate optimization
  - Memory leak detection

### Technical Notes

Use Rails caching best practices and consider implementing background job processing for expensive operations.

---

## Issue #76: Mobile Responsiveness and Progressive Enhancement

**Labels**: `feature`, `phase-4`, `frontend`  
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Milestone**: Phase 4 - Polish & Performance  
**Depends on**: #75

### Description

Ensure all show and setlist features work perfectly on mobile devices with progressive enhancement and offline capabilities.

### Acceptance Criteria

- [ ] All show and setlist pages work perfectly on mobile
- [ ] Touch-friendly navigation and interactions
- [ ] Progressive loading for large setlists
- [ ] Offline capability for basic browsing

### Tasks

#### Mobile-First Design

- [ ] **Mobile-first responsive design**
  - Responsive breakpoints for all show pages
  - Touch-friendly buttons and navigation
  - Mobile-optimized search interface
  - Swipe gestures for show navigation

#### Progressive Enhancement

- [ ] **Progressive enhancement**
  - Progressive loading for large setlists
  - Lazy loading for images and non-critical content
  - Service worker for offline capability
  - Progressive Web App features

#### Mobile Performance

- [ ] **Performance on mobile**
  - Minimize JavaScript bundle size
  - Optimize image loading and sizing
  - Touch response time optimization
  - Battery usage considerations

#### Testing Requirements

- [ ] **Mobile Testing** (`spec/system/mobile_spec.rb`)
  - Cross-device compatibility testing
  - Touch interaction testing
  - Performance on slower connections
  - Offline functionality testing

### Technical Notes

Follow mobile-first design principles and ensure accessibility compliance across all devices.

---

## Issue #77: Advanced Analytics and Insights

**Labels**: `feature`, `phase-4`, `frontend`  
**Priority**: Low  
**Estimated Effort**: 2-3 days  
**Milestone**: Phase 4 - Polish & Performance  
**Depends on**: #76

### Description

Create comprehensive analytics dashboard with meaningful insights about show patterns, song frequency, and historical trends.

### Acceptance Criteria

- [ ] Show analytics provide meaningful insights
- [ ] Song frequency and rarity statistics
- [ ] Historical trends and patterns
- [ ] Data visualization for complex relationships

### Tasks

#### Analytics Dashboard

- [ ] **Create analytics dashboard** (`app/views/analytics/`)
  - Show frequency by venue and year
  - Song performance statistics and trends
  - Album representation over time
  - Cover song usage patterns

#### Data Visualization

- [ ] **Data visualization** (`app/javascript/analytics/`)
  - Interactive charts for song frequency
  - Timeline visualization for band evolution
  - Geographic mapping of show locations
  - Audio feature distribution charts

#### Insight Generation

- [ ] **Insight generation** (`app/services/analytics_service.rb`)
  - Rarity scoring for songs and shows
  - Historical significance indicators
  - Pattern recognition in setlist construction
  - Comparative analysis tools

#### Testing Requirements

- [ ] **Analytics Tests** (`spec/system/analytics_spec.rb`)
  - Statistical calculation accuracy
  - Chart rendering and interactivity
  - Performance with complex datasets
  - Data export functionality

### Technical Notes

Use established charting libraries (Chart.js, D3.js) and ensure data visualizations are accessible and mobile-friendly.

---

## GitHub Issue Creation Instructions

1. **Create each issue** with the title and description above
2. **Add labels** as specified for each issue
3. **Set milestones** for phase organization
4. **Configure dependencies** by referencing issue numbers
5. **Assign priorities** (High/Medium/Low) as indicated
6. **Add time estimates** to project planning tools

## Suggested Milestones

- **Phase 1 - Foundation** (Issues #64-68)
- **Phase 2 - Album Integration** (Issues #69-71)  
- **Phase 3 - Cover Songs & Audio** (Issues #72-74)
- **Phase 4 - Polish & Performance** (Issues #75-77)

## Suggested Labels

Create these labels in your repository:
- `feature` (blue)
- `phase-1`, `phase-2`, `phase-3`, `phase-4` (different colors)
- `backend` (red)
- `frontend` (green)
- `database` (purple)

This structured approach will provide excellent project visibility and enable efficient development tracking.