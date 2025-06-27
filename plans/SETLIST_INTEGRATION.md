# DMB Setlist Integration Plan

## Executive Summary

This document outlines the comprehensive integration of Dave Matthews Band setlist data into The Art Exchange application. The project will transform the application from a poster-focused catalog into a rich music performance database with enhanced discovery capabilities.

**Scope**: 1,084 DMB setlist JSON files spanning 1991-2024  
**Goal**: Create comprehensive show pages with setlist data, enhanced poster displays, and rich musical metadata  
**Architecture**: Extensible database design supporting multiple bands and future user interaction features

## Phase 1: Foundation - Core Setlist Integration

### Issue #64: Database Schema for Shows and Setlists
**Priority**: High  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-1`, `backend`, `database`

#### Acceptance Criteria
- [ ] Create comprehensive database schema for shows, songs, and setlist relationships
- [ ] All tables have proper indexes for performance
- [ ] Foreign key constraints maintain data integrity
- [ ] Schema supports multiple bands (not just DMB)
- [ ] Migration runs successfully in all environments

#### Subtasks
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

---

### Issue #65: Core Models with Associations and Validations
**Priority**: High  
**Estimated Effort**: 2-3 days  
**Labels**: `feature`, `phase-1`, `backend`

#### Acceptance Criteria
- [ ] All new models have comprehensive associations
- [ ] Validation rules ensure data integrity
- [ ] Models include helpful query scopes
- [ ] Slug generation works for URLs
- [ ] Models support search functionality

#### Subtasks
- [ ] **Create Show model**
  - Associations: `belongs_to :band`, `belongs_to :venue`, `has_many :setlist_songs`, `has_many :songs, through: :setlist_songs`, `has_many :posters`
  - Validations: presence of band, venue, show_date; uniqueness of band+venue+date combination
  - Scopes: `by_year`, `by_venue`, `by_band`, `chronological`, `recent`
  - Slug generation from band-venue-date
  - Methods: `display_name`, `formatted_date`, `total_songs`, `encore_songs`

- [ ] **Create Song model**
  - Associations: `has_many :setlist_songs`, `has_many :shows, through: :setlist_songs`, `has_and_belongs_to_many :albums`
  - Validations: presence of title, uniqueness of title (case insensitive)
  - Scopes: `covers`, `originals`, `frequently_played`, `rarely_played`, `by_first_performance`
  - Search: pg_search integration for title and artist_credit
  - Methods: `is_cover?`, `performance_count`, `last_performed_at`, `debut_show`

- [ ] **Create Album model**
  - Associations: `belongs_to :band`, `has_and_belongs_to_many :songs`
  - Validations: presence of title and band, uniqueness of title per band
  - Scopes: `studio_albums`, `live_albums`, `by_release_date`, `by_band`
  - Methods: `track_count`, `release_year`, `album_type_display`

- [ ] **Create SetlistSong model**
  - Associations: `belongs_to :show`, `belongs_to :song`
  - Validations: presence of show, song, set_type, position; uniqueness of position within set_type per show
  - Scopes: `main_set`, `encore`, `with_guests`, `with_notes`
  - Methods: `has_guests?`, `has_segue?`, `special_performance?`

- [ ] **Update Poster model**
  - Add association: `belongs_to :show, optional: true`
  - Add method: `has_setlist?` to check if poster has associated show data
  - Update display methods to include show information when available

#### Testing Requirements
- [ ] **Model Tests**
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

---

### Issue #66: Setlist JSON Import System
**Priority**: High  
**Estimated Effort**: 4-5 days  
**Labels**: `feature`, `phase-1`, `backend`

#### Acceptance Criteria
- [ ] Rake task imports all 1,084 setlist JSON files successfully
- [ ] Venue matching/creation works for all locations
- [ ] Song deduplication handles variations and typos
- [ ] Show records are created with proper associations
- [ ] Import is idempotent (can be run multiple times safely)
- [ ] Progress reporting and error handling

#### Subtasks
- [ ] **Create SetlistImportService**
  - Parse JSON files and extract show data
  - Match venues by name and location (fuzzy matching)
  - Create new venues for unmatched locations
  - Deduplicate songs by title (handle variations like "Song Title *", "Song Title [Dave Solo]")
  - Create show records with proper slug generation
  - Handle guest performances and special notes

- [ ] **Create VenueMatchingService**
  - Fuzzy string matching for venue names
  - Location-based matching (city, state)
  - Handle venue name variations and abbreviations
  - Create new venue records with geocoding
  - Update venue previous_names array for future matching

- [ ] **Create SongDeduplicationService**
  - Normalize song titles (remove special characters, brackets, etc.)
  - Handle common variations and abbreviations
  - Identify cover songs from context
  - Maintain original title format while creating normalized lookup

- [ ] **Create rake task: `setlists:import`**
  - Process all JSON files in tools/dmb_scraper/setlists
  - Show progress bar and statistics
  - Error logging with file-specific details
  - Rollback capability for failed imports
  - Option to import specific date ranges

- [ ] **Create rake task: `setlists:validate`**
  - Check data integrity after import
  - Report missing venues or unmatched songs
  - Validate setlist ordering and completeness
  - Generate import statistics and summary report

#### Testing Requirements
- [ ] **Service Tests**
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

---

### Issue #67: Basic Show Pages and Routing
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-1`, `frontend`

#### Acceptance Criteria
- [ ] Show pages display complete setlist information
- [ ] Routes follow RESTful conventions with slugs
- [ ] Shows are browsable by year, venue, and band
- [ ] Basic search functionality for shows
- [ ] Mobile-responsive design
- [ ] SEO-friendly URLs and meta tags

#### Subtasks
- [ ] **Create ShowsController**
  - `index` action with filtering by year, venue, band
  - `show` action with slug-based lookup
  - Search functionality for show dates and venues
  - Pagination for large result sets
  - JSON API endpoints for future AJAX features

- [ ] **Create show views**
  - `shows/index.html.erb` - browsable show listing with filters
  - `shows/show.html.erb` - detailed show page with complete setlist
  - Responsive grid layout for show cards
  - Setlist display with main set and encore sections
  - Guest musician highlighting
  - Links to associated posters (if any)

- [ ] **Update routes.rb**
  - RESTful show routes with slug parameter
  - Nested routes for band shows and venue shows
  - Search routes with query parameters
  - API namespace for JSON endpoints

- [ ] **Create navigation updates**
  - Add "Shows" to main navigation menu
  - Show count in navigation (e.g., "Shows (1,084)")
  - Breadcrumb navigation for show browsing
  - Filter sidebar for show discovery

#### Testing Requirements
- [ ] **Controller Tests**
  - All actions return correct HTTP status
  - Filtering and search functionality works
  - Pagination works correctly
  - JSON API responses format correctly

- [ ] **View Tests**
  - All show data displays correctly
  - Responsive design works on mobile
  - Links to related content work
  - SEO meta tags are present

- [ ] **System Tests**
  - Full user journey from navigation to show details
  - Search and filter interactions
  - Mobile navigation and display
  - Performance with large datasets

---

### Issue #68: Poster-Show Linking System
**Priority**: Medium  
**Estimated Effort**: 2-3 days  
**Labels**: `feature`, `phase-1`, `backend`

#### Acceptance Criteria
- [ ] Existing posters automatically link to matching shows
- [ ] Poster show pages display setlist information
- [ ] Unmatched posters and shows are identified
- [ ] Manual linking interface for admin users
- [ ] Historical data integrity maintained

#### Subtasks
- [ ] **Create PosterShowMatchingService**
  - Match posters to shows by band, venue, and date
  - Handle date discrepancies (poster release vs. show date)
  - Fuzzy matching for venue name variations
  - Report unmatched posters and shows for manual review

- [ ] **Update PosterController**
  - Display setlist information on poster show pages
  - Link to full show page from poster details
  - Show "No setlist available" state gracefully

- [ ] **Create admin matching interface**
  - List unmatched posters and shows
  - Manual linking functionality for admin users
  - Bulk operations for common patterns
  - Undo capability for incorrect matches

- [ ] **Create rake task: `posters:link_shows`**
  - Run automated matching process
  - Generate report of successful and failed matches
  - Option to auto-link high-confidence matches
  - Export unmatched items for manual review

#### Testing Requirements
- [ ] **Service Tests**
  - Matching accuracy with known poster-show pairs
  - Edge cases (multiple shows same day, venue name changes)
  - Performance with large datasets

- [ ] **Integration Tests**
  - Poster pages display setlist data correctly
  - Admin interface functions properly
  - Automated matching maintains data integrity

---

## Phase 2: Album Integration - Rich Musical Metadata

### Issue #69: MusicBrainz API Integration Service
**Priority**: Medium  
**Estimated Effort**: 4-5 days  
**Labels**: `feature`, `phase-2`, `backend`

#### Acceptance Criteria
- [ ] Service integrates with MusicBrainz API
- [ ] DMB discography imported automatically
- [ ] Songs linked to albums with track information
- [ ] Rate limiting and error handling implemented
- [ ] Data caching for performance

#### Subtasks
- [ ] **Create MusicBrainzService**
  - API client with authentication and rate limiting
  - DMB artist lookup using known artist ID
  - Release (album) fetching with detailed metadata
  - Recording (song) matching and relationship data
  - Error handling and retry logic for API failures

- [ ] **Create AlbumImportService**
  - Import all DMB studio albums from MusicBrainz
  - Import live albums and official releases
  - Handle DMB Live Trax series (100+ official bootlegs)
  - Create album-song relationships with track numbers
  - Update existing songs with album information

- [ ] **Create rake task: `albums:import_from_musicbrainz`**
  - Fetch complete DMB discography
  - Match imported songs to existing setlist songs
  - Report unmatched songs and albums
  - Progress tracking and error logging

- [ ] **Implement caching strategy**
  - Cache MusicBrainz API responses locally
  - Periodic cache refresh for updated data
  - Cache invalidation strategies

#### Testing Requirements
- [ ] **API Integration Tests**
  - Mock MusicBrainz API responses
  - Rate limiting compliance tests
  - Error handling and retry logic tests
  - Cache functionality tests

- [ ] **Data Quality Tests**
  - Imported album data accuracy
  - Song-album relationship correctness
  - Duplicate detection and handling

---

### Issue #70: Album Model and Song-Album Relationships
**Priority**: Medium  
**Estimated Effort**: 2-3 days  
**Labels**: `feature`, `phase-2`, `backend`

#### Acceptance Criteria
- [ ] Album model fully functional with associations
- [ ] Song-album relationships properly established
- [ ] Album browsing and display functionality
- [ ] Track listing features work correctly

#### Subtasks
- [ ] **Enhance Album model**
  - Complete association setup with songs
  - Album artwork support via Active Storage
  - Album statistics (track count, total duration)
  - Search functionality for album titles

- [ ] **Create album-related views**
  - Album index page with filtering
  - Individual album pages with track listings
  - Album artwork display
  - Links from songs to their albums

- [ ] **Update song displays**
  - Show album information on song pages
  - "Appears on albums" section for songs
  - Album cover thumbnails in setlists

#### Testing Requirements
- [ ] **Model Tests**
  - Album-song association tests
  - Album statistics calculation tests
  - Search functionality tests

- [ ] **View Tests**
  - Album listing and detail pages
  - Song-album cross-linking
  - Image display and responsiveness

---

### Issue #71: Enhanced Show Pages with Album Context
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-2`, `frontend`

#### Acceptance Criteria
- [ ] Show pages display album information for each song
- [ ] Album artwork appears in setlists
- [ ] Show statistics include album distribution
- [ ] Historical context provided for deep cuts and rarities

#### Subtasks
- [ ] **Enhance show display views**
  - Album information overlay on songs in setlists
  - Album artwork thumbnails for visual appeal
  - "From the album..." contextual information
  - Rarity indicators for seldom-played album tracks

- [ ] **Create show analytics**
  - Album distribution charts for shows
  - Era analysis (which albums/periods represented)
  - Deep cuts vs. hits ratio
  - Historical significance indicators

- [ ] **Improve show search and filtering**
  - Filter shows by album representation
  - Search for shows featuring specific albums
  - "Similar shows" recommendations based on setlist content

#### Testing Requirements
- [ ] **Integration Tests**
  - Album data displays correctly in setlists
  - Show analytics calculate properly
  - Enhanced search functionality works

- [ ] **Performance Tests**
  - Page load times with rich metadata
  - Database query optimization
  - Image loading and caching

---

## Phase 3: Cover Songs & Audio Features

### Issue #72: Cover Song Identification and Metadata
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-3`, `backend`

#### Acceptance Criteria
- [ ] Cover songs automatically identified from setlist data
- [ ] Original artist information populated
- [ ] Cover song browsing and statistics
- [ ] Integration with external cover song databases

#### Subtasks
- [ ] **Create CoverSongService**
  - Identify covers from song titles and setlist context
  - Integrate with SecondHandSongs.com for original artist data
  - Cross-reference with Setlist.fm cover databases
  - Handle common cover variations and alternate titles

- [ ] **Enhance Song model for covers**
  - Cover song indicators and original artist fields
  - Cover song statistics and first performance tracking
  - Cover browsing by original artist or era

- [ ] **Create cover song displays**
  - Dedicated cover song section
  - Original artist highlighting in setlists
  - Cover song statistics and trends
  - "DMB's interpretation of..." contextual information

#### Testing Requirements
- [ ] **Service Tests**
  - Cover song identification accuracy
  - Original artist data retrieval
  - Edge cases and false positives

- [ ] **Feature Tests**
  - Cover song browsing functionality
  - Statistics calculation accuracy
  - Display correctness

---

### Issue #73: Spotify API Integration for Audio Features
**Priority**: Medium  
**Estimated Effort**: 4-5 days  
**Labels**: `feature`, `phase-3`, `backend`

#### Acceptance Criteria
- [ ] Songs matched to Spotify tracks
- [ ] Audio features imported (tempo, energy, danceability, etc.)
- [ ] Audio-based show analysis and recommendations
- [ ] Spotify Web API integration with OAuth

#### Subtasks
- [ ] **Create SpotifyService**
  - OAuth integration for Spotify Web API
  - Song matching using artist and title
  - Audio features retrieval and storage
  - Rate limiting and token refresh handling

- [ ] **Create AudioFeaturesService**
  - Process and normalize Spotify audio features
  - Calculate show-level audio statistics
  - Generate mood and energy profiles for shows
  - Audio-based similarity algorithms

- [ ] **Create audio-based discovery features**
  - Filter shows by energy, tempo, danceability
  - "Shows like this one" based on audio features
  - Mood-based playlists and recommendations
  - Audio feature visualization

#### Testing Requirements
- [ ] **API Integration Tests**
  - Spotify OAuth flow tests
  - Audio features retrieval accuracy
  - Rate limiting compliance

- [ ] **Algorithm Tests**
  - Audio feature calculation correctness
  - Similarity algorithm accuracy
  - Performance with large datasets

---

### Issue #74: Advanced Search and Discovery Features
**Priority**: Low  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-3`, `frontend`

#### Acceptance Criteria
- [ ] Advanced search supports multiple criteria
- [ ] Audio-based filtering and discovery
- [ ] Recommendation engine for shows and songs
- [ ] Saved searches and user preferences

#### Subtasks
- [ ] **Enhanced search interface**
  - Multi-criteria search (date, venue, songs, album, audio features)
  - Advanced filters with boolean logic
  - Search result sorting and grouping
  - Search history and saved searches

- [ ] **Recommendation engine**
  - "If you liked this show..." recommendations
  - Similar song identification
  - User preference learning (future enhancement)
  - Discovery suggestions based on listening patterns

- [ ] **Audio-based discovery**
  - Mood-based show browsing
  - Energy level filtering
  - Tempo-based recommendations
  - Audio feature visualization charts

#### Testing Requirements
- [ ] **Search Tests**
  - Complex query accuracy
  - Performance with large result sets
  - Filter combination logic

- [ ] **Recommendation Tests**
  - Algorithm accuracy validation
  - Performance benchmarks
  - User experience testing

---

## Phase 4: User Experience & Performance

### Issue #75: Performance Optimization and Caching
**Priority**: High  
**Estimated Effort**: 2-3 days  
**Labels**: `feature`, `phase-4`, `backend`

#### Acceptance Criteria
- [ ] Page load times under 2 seconds for show pages
- [ ] Database queries optimized with proper indexing
- [ ] Caching strategy implemented for frequently accessed data
- [ ] Memory usage optimized for large datasets

#### Subtasks
- [ ] **Database optimization**
  - Add missing indexes for common queries
  - Optimize N+1 queries with includes/preload
  - Database query analysis and tuning
  - Connection pooling optimization

- [ ] **Implement caching layers**
  - Page-level caching for show pages
  - Fragment caching for setlists and song data
  - API response caching for external services
  - Cache invalidation strategies

- [ ] **Performance monitoring**
  - Query performance monitoring
  - Page load time tracking
  - Memory usage monitoring
  - Error rate tracking

#### Testing Requirements
- [ ] **Performance Tests**
  - Load testing with realistic data volumes
  - Database query performance benchmarks
  - Cache hit rate optimization
  - Memory leak detection

---

### Issue #76: Mobile Responsiveness and Progressive Enhancement
**Priority**: Medium  
**Estimated Effort**: 3-4 days  
**Labels**: `feature`, `phase-4`, `frontend`

#### Acceptance Criteria
- [ ] All show and setlist pages work perfectly on mobile
- [ ] Touch-friendly navigation and interactions
- [ ] Progressive loading for large setlists
- [ ] Offline capability for basic browsing

#### Subtasks
- [ ] **Mobile-first responsive design**
  - Responsive breakpoints for all show pages
  - Touch-friendly buttons and navigation
  - Mobile-optimized search interface
  - Swipe gestures for show navigation

- [ ] **Progressive enhancement**
  - Progressive loading for large setlists
  - Lazy loading for images and non-critical content
  - Service worker for offline capability
  - Progressive Web App features

- [ ] **Performance on mobile**
  - Minimize JavaScript bundle size
  - Optimize image loading and sizing
  - Touch response time optimization
  - Battery usage considerations

#### Testing Requirements
- [ ] **Mobile Testing**
  - Cross-device compatibility testing
  - Touch interaction testing
  - Performance on slower connections
  - Offline functionality testing

---

### Issue #77: Advanced Analytics and Insights
**Priority**: Low  
**Estimated Effort**: 2-3 days  
**Labels**: `feature`, `phase-4`, `frontend`

#### Acceptance Criteria
- [ ] Show analytics provide meaningful insights
- [ ] Song frequency and rarity statistics
- [ ] Historical trends and patterns
- [ ] Data visualization for complex relationships

#### Subtasks
- [ ] **Create analytics dashboard**
  - Show frequency by venue and year
  - Song performance statistics and trends
  - Album representation over time
  - Cover song usage patterns

- [ ] **Data visualization**
  - Interactive charts for song frequency
  - Timeline visualization for band evolution
  - Geographic mapping of show locations
  - Audio feature distribution charts

- [ ] **Insight generation**
  - Rarity scoring for songs and shows
  - Historical significance indicators
  - Pattern recognition in setlist construction
  - Comparative analysis tools

#### Testing Requirements
- [ ] **Analytics Tests**
  - Statistical calculation accuracy
  - Chart rendering and interactivity
  - Performance with complex datasets
  - Data export functionality

---

## Technical Implementation Notes

### Database Design Principles
- **Extensibility**: Schema supports multiple bands beyond DMB
- **Performance**: Comprehensive indexing strategy for common queries
- **Integrity**: Foreign key constraints and validation rules maintain data quality
- **Flexibility**: JSON columns for variable metadata and future enhancements

### API Integration Strategy
- **Rate Limiting**: Respect external API limits with appropriate backoff strategies
- **Caching**: Local caching reduces API calls and improves performance
- **Error Handling**: Graceful degradation when external services are unavailable
- **Data Quality**: Validation and cleaning of external data before storage

### Testing Strategy
- **Unit Tests**: Comprehensive coverage of models, services, and utilities
- **Integration Tests**: Test cross-system functionality and API integrations
- **System Tests**: End-to-end user journeys and performance validation
- **Performance Tests**: Load testing and optimization validation

### Security Considerations
- **API Keys**: Secure storage and rotation of external service credentials
- **Input Validation**: Sanitization of all external data sources
- **Access Control**: Admin-only features properly protected
- **Data Privacy**: No sensitive user data stored unnecessarily

### Future Extensibility
- **Multi-Band Support**: Architecture supports other artists and bands
- **User Features**: Foundation for user show attendance tracking and social features
- **Machine Learning**: Data structure supports future recommendation algorithms
- **Mobile Apps**: API-first design enables future mobile applications

---

## Project Timeline

**Phase 1 (Foundation)**: 3-4 weeks
- Issues #64-68: Core database, models, import system, and basic display

**Phase 2 (Album Integration)**: 2-3 weeks  
- Issues #69-71: MusicBrainz integration and enhanced show context

**Phase 3 (Cover Songs & Audio)**: 2-3 weeks
- Issues #72-74: Cover song metadata and Spotify audio features

**Phase 4 (Polish & Performance)**: 1-2 weeks
- Issues #75-77: Performance optimization and enhanced user experience

**Total Estimated Timeline**: 8-12 weeks

---

## Success Metrics

### Technical Metrics
- [ ] All 1,084 setlists imported successfully
- [ ] 95%+ poster-show matching accuracy
- [ ] Page load times under 2 seconds
- [ ] 90%+ test coverage maintained
- [ ] Zero data integrity issues

### User Experience Metrics
- [ ] Rich setlist data enhances poster pages
- [ ] Show discovery enables new exploration patterns
- [ ] Mobile experience fully functional
- [ ] Search finds relevant results quickly
- [ ] Analytics provide meaningful insights

### Data Quality Metrics
- [ ] Complete venue information for all shows
- [ ] Album information for 80%+ of songs
- [ ] Cover song identification for known covers
- [ ] Audio features for 70%+ of songs via Spotify
- [ ] Comprehensive error logging and monitoring

This comprehensive plan provides a structured approach to transforming The Art Exchange into a premier Dave Matthews Band performance database while maintaining the existing poster-focused functionality and laying the groundwork for future enhancements.